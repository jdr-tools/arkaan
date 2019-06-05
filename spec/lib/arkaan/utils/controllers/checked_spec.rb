RSpec.describe Arkaan::Utils::Controllers::Checked do

  let!(:account) { create(:account) }
  let!(:gateway) { create(:gateway) }
  let!(:premium_application) { create(:premium_application, creator: account) }
  let!(:application) { create(:not_premium_application, creator: account) }
  let!(:service) { create(:service) }

  # This group is here to test the adding of routes to a superuser group at declaration.
  let!(:group) { create(:group, is_superuser: true) }

  before do
    allow(Arkaan::Utils::MicroService.instance).to receive(:service).and_return(service)

    class TestController < Arkaan::Utils::Controllers::Checked
      config_file File.join(File.dirname(File.absolute_path(__FILE__)), '..', '..', '..', 'config', 'errors.yml')

      declare_premium_route('get', '/') do
        halt 200, {message: 'test_message'}.to_json
      end
      declare_premium_route('post', '/') do
        halt 201, {message: 'created'}.to_json
      end
      declare_premium_route('put', '/') do
        halt 200, {message: 'updated'}.to_json
      end
      declare_premium_route('delete', '/') do
        halt 200, {message: 'deleted'}.to_json
      end
      declare_route('get', '/badrequest') do
        raise Arkaan::Utils::Errors::BadRequest.new(action: 'test_errors', field: 'test_field', error: 'test_error')
      end
      declare_route('get', '/forbidden') do
        raise Arkaan::Utils::Errors::Forbidden.new(action: 'test_errors', field: 'test_field', error: 'test_error')
      end
      declare_route('get', '/notfound') do
        raise Arkaan::Utils::Errors::NotFound.new(action: 'test_errors', field: 'test_field', error: 'test_error')
      end
    end

    def app
      TestController.new
    end
  end

  describe 'Super user group' do
    before do
      group.reload
    end
    it 'has the correct number of routes declared after controller creation' do
      expect(group.routes.count).to be 7
    end
    describe 'GET route' do
      it 'has a GET route' do
        expect(group.routes.where(verb: 'get', path: '/').count).to be 1
      end
      it 'has a GET route with the correct path' do
        expect(group.routes.where(verb: 'get', path: '/').first.path).to eq '/'
      end
    end
    describe 'POST route' do
      it 'has a POST route' do
        expect(group.routes.where(verb: 'post', path: '/').count).to be 1
      end
      it 'has a POST route with the correct path' do
        expect(group.routes.where(verb: 'post', path: '/').first.path).to eq '/'
      end
    end
    describe 'PUT route' do
      it 'has a PUT route' do
        expect(group.routes.where(verb: 'put', path: '/').count).to be 1
      end
      it 'has a PUT route with the correct path' do
        expect(group.routes.where(verb: 'put', path: '/').first.path).to eq '/'
      end
    end
    describe 'DELETE route' do
      it 'has a DELETE route' do
        expect(group.routes.where(verb: 'delete', path: '/').count).to be 1
      end
      it 'has a DELETE route with the correct path' do
        expect(group.routes.where(verb: 'delete', path: '/').first.path).to eq '/'
      end
    end
  end

  describe 'GET request' do
    include_examples 'micro_service route', verb: 'get', basepath: '/example'
  end
  describe 'POST request' do
    include_examples 'micro_service route', verb: 'post', expected_status: 201, expected_body: {'message' => 'created'}, basepath: '/example'
  end
  describe 'PUT request' do
    include_examples 'micro_service route', verb: 'put', expected_body: {'message' => 'updated'}, basepath: '/example'
  end
  describe 'DELETE request' do
    include_examples 'micro_service route', verb: 'delete', expected_body: {'message' => 'deleted'}, basepath: '/example'
  end

  describe 'automatic exceptions' do
    describe 'bad request exception' do
      before do
        get '/example/badrequest', {token: 'test_token', app_key: 'test_key'}
      end
      it 'Returns a Bad Request (400) status' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 400,
          field: 'test_field',
          error: 'test_error',
          docs: 'anything'
        })
      end
    end
    describe 'forbidden exceptions' do
      before do
        get '/example/forbidden', {token: 'test_token', app_key: 'test_key'}
      end
      it 'Returns a Forbidden (403) status' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 403,
          field: 'test_field',
          error: 'test_error',
          docs: 'anything'
        })
      end
    end
    describe 'not found exceptions' do
      before do
        get '/example/notfound', {token: 'test_token', app_key: 'test_key'}
      end
      it 'Returns a Not Found (404) status' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 404,
          field: 'test_field',
          error: 'test_error',
          docs: 'anything'
        })
      end
    end
  end

  describe :declare_routes do

    before :each do
      Arkaan::Monitoring::Route.delete_all
    end

    describe 'When the route does not already exists' do
      before do
        allow(Arkaan::Utils::MicroService.instance).to receive(:service).and_return(service)

        class NonPremiumTestController < Arkaan::Utils::Controllers::Checked
          declare_route('get', '/') do
            halt 200, {message: 'test_message'}.to_json
          end
        end

        def app
          NonPremiumTestController.new
        end
      end

      it 'Has created a route' do
        expect(Arkaan::Monitoring::Route.all.count).to be 1
      end
      describe 'route parameters' do
        let!(:route) { Arkaan::Monitoring::Route.first }

        it 'has created a route with the correct path' do
          expect(route.path).to eq '/'
        end
        it 'has created a route with the correct verb' do
          expect(route.verb).to eq 'get'
        end
        it 'has created a non-premium route' do
          expect(route.premium).to be false
        end
      end
      describe 'call to the route' do
        before do
          get '/example', {app_key: 'test_key', token: 'test_token'}
        end
        it 'correctly calls the route when all parameters are rightly given' do
          expect(last_response.status).to be 200
        end
        it 'returns the correct body for the nominal case' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'test_message'})
        end
      end
    end
    describe 'When the route already exists' do
      before do
        allow(Arkaan::Utils::MicroService.instance).to receive(:service).and_return(service)
        create(:route, verb: 'post', path: '/', premium: false, service: service)

        class NonPremiumTestController < Arkaan::Utils::Controllers::Checked
          declare_route('post', '/') do
            halt 200, {message: 'test_message'}.to_json
          end
        end

        def app
          NonPremiumTestController.new
        end
      end
      it 'Has created a route' do
        expect(Arkaan::Monitoring::Route.all.count).to be 1
      end
      describe 'route parameters' do
        let!(:route) { Arkaan::Monitoring::Route.first }

        it 'has created a route with the correct path' do
          expect(route.path).to eq '/'
        end
        it 'has created a route with the correct verb' do
          expect(route.verb).to eq 'post'
        end
        it 'has created a non-premium route' do
          expect(route.premium).to be false
        end
      end
      describe 'call to the route' do
        before do
          post '/example', {app_key: 'test_key', token: 'test_token'}.to_json
        end
        it 'correctly calls the route when all parameters are rightly given' do
          expect(last_response.status).to be 200
        end
        it 'returns the correct body for the nominal case' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'test_message'})
        end
      end
    end
    describe 'When the route does not need an authentication' do
      before do
        allow(Arkaan::Utils::MicroService.instance).to receive(:service).and_return(service)

        class NotAuthenticatedTestController < Arkaan::Utils::Controllers::Checked
          declare_route('get', '/', options: {authenticated: false}) do
            halt 200, {message: 'test_message'}.to_json
          end
        end

        def app
          NotAuthenticatedTestController.new
        end
      end

      it 'Has created a route' do
        expect(Arkaan::Monitoring::Route.all.count).to be 1
      end
      describe 'route parameters' do
        let!(:route) { Arkaan::Monitoring::Route.first }

        it 'has created a route with the correct path' do
          expect(route.path).to eq '/'
        end
        it 'has created a route with the correct verb' do
          expect(route.verb).to eq 'get'
        end
        it 'has created a non-premium route' do
          expect(route.premium).to be false
        end
        it 'has created a non-authenticated route' do
          expect(route.authenticated).to be false
        end
      end
    end
  end

  describe :declare_premium_route do

    before :each do
      Arkaan::Monitoring::Route.delete_all
    end

    describe 'When the route does not already exists' do
      before do
        allow(Arkaan::Utils::MicroService.instance).to receive(:service).and_return(service)

        class PremiumTestController < Arkaan::Utils::Controllers::Checked
          declare_premium_route('get', '/') do
            halt 200, {message: 'test_message'}.to_json
          end
        end

        def app
          PremiumTestController.new
        end
      end

      it 'Has created a route' do
        expect(Arkaan::Monitoring::Route.all.count).to be 1
      end
      describe 'route parameters' do
        let!(:route) { Arkaan::Monitoring::Route.first }

        it 'has created a route with the correct path' do
          expect(route.path).to eq '/'
        end
        it 'has created a route with the correct verb' do
          expect(route.verb).to eq 'get'
        end
        it 'has created a non-premium route' do
          expect(route.premium).to be true
        end
      end
      describe 'call to the route' do
        before do
          get '/example', {app_key: 'test_key', token: 'test_token'}
        end
        it 'correctly calls the route when all parameters are rightly given' do
          expect(last_response.status).to be 200
        end
        it 'returns the correct body for the nominal case' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'test_message'})
        end
      end
    end
    describe 'When the route already exists' do
      before do
        allow(Arkaan::Utils::MicroService.instance).to receive(:service).and_return(service)
        create(:route, verb: 'post', path: '/', premium: true, service: service)

        class PremiumTestController < Arkaan::Utils::Controllers::Checked
          declare_premium_route('post', '/') do
            halt 200, {message: 'test_message'}.to_json
          end
        end

        def app
          PremiumTestController.new
        end
      end

      it 'Has created a route' do
        expect(Arkaan::Monitoring::Route.all.count).to be 1
      end
      describe 'route parameters' do
        let!(:route) { Arkaan::Monitoring::Route.first }

        it 'has created a route with the correct path' do
          expect(route.path).to eq '/'
        end
        it 'has created a route with the correct verb' do
          expect(route.verb).to eq 'post'
        end
        it 'has created a non-premium route' do
          expect(route.premium).to be true
        end
      end
      describe 'call to the route' do
        before do
          post '/example', {app_key: 'test_key', token: 'test_token'}.to_json
        end
        it 'correctly calls the route when all parameters are rightly given' do
          expect(last_response.status).to be 200
        end
        it 'returns the correct body for the nominal case' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'test_message'})
        end
      end
    end
  end

  describe :check_presence do
    before do
      class CheckPresenceTestController < Arkaan::Utils::Controllers::Checked
        config_file File.join(File.dirname(File.absolute_path(__FILE__)), '..', '..', '..', 'config', 'errors.yml')

        declare_route('get', '/check_presence_test') do
          check_presence('field', 'other_field', route: 'check_presence')
        end
      end
      def app
        CheckPresenceTestController.new
      end
    end
    describe 'first field' do
      before do
        get '/example/check_presence_test', {app_key: 'test_key', token: 'test_token', other_field: 'value'}
      end
      it 'Returns a Bad Request (400) status' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 400,
          field: 'field',
          error: 'required',
          docs: 'url_field_required'
        })
      end
    end
    describe 'second field' do
      before do
        get '/example/check_presence_test', {app_key: 'test_key', token: 'test_token', field: 'value'}
      end
      it 'Returns a Bad Request (400) status' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 400,
          field: 'other_field',
          error: 'required',
          docs: 'url_other_field_required'
        })
      end
    end
  end

  describe :check_either_presence do
    before do
      class CheckPresenceTestController < Arkaan::Utils::Controllers::Checked
        config_file File.join(File.dirname(File.absolute_path(__FILE__)), '..', '..', '..', 'config', 'errors.yml')

        declare_route('get', '/check_either_presence_test') do
          check_either_presence('field', 'other_field', route: 'check_either_presence', key: 'any_id')
          halt 200, {message: 'done'}.to_json
        end
      end
      def app
        CheckPresenceTestController.new
      end
    end
    describe 'first field' do
      before do
        get '/example/check_either_presence_test', {app_key: 'test_key', token: 'test_token', other_field: 'value'}
      end
      it 'Returns a Bad Request (400) status' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({message: 'done'})
      end
    end
    describe 'second field' do
      before do
        get '/example/check_either_presence_test', {app_key: 'test_key', token: 'test_token', field: 'value'}
      end
      it 'Returns a Bad Request (400) status' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({message: 'done'})
      end
    end
    describe 'No field given' do
      before do
        get '/example/check_either_presence_test', {app_key: 'test_key', token: 'test_token'}
      end
      it 'Returns a Bad Request (400) status' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 400,
          field: 'any_id',
          error: 'required',
          docs: 'any_id_required'
        })
      end
    end
  end
end