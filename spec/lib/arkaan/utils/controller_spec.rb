class TestController < Arkaan::Utils::Controller
  get '/' do
    halt 200, {message: 'test_message'}.to_json
  end
  post '/' do
    halt 201, {message: 'created'}.to_json
  end
  put '/' do
    halt 200, {message: 'updated'}.to_json
  end
  delete '/' do
    halt 200, {message: 'deleted'}.to_json
  end
end

RSpec.describe TestController do

  def app
    TestController.new
  end

  let!(:account) { create(:account) }
  let!(:gateway) { create(:gateway) }
  let!(:premium_application) { create(:premium_application, creator: account) }
  let!(:application) { create(:not_premium_application, creator: account) }
  let!(:service) { create(:service) }


  describe 'GET request' do
    include_examples 'micro_service route', verb: 'get'
  end
  describe 'POST request' do
    include_examples 'micro_service route', verb: 'post', expected_status: 201, expected_body: {'message' => 'created'}
  end
  describe 'PUT request' do
    include_examples 'micro_service route', verb: 'put', expected_body: {'message' => 'updated'}
  end
  describe 'DELETE request' do
    include_examples 'micro_service route', verb: 'delete', expected_body: {'message' => 'deleted'}
  end

  describe :declare_routes do

    describe 'When the route does not already exists' do
      before do
        allow(Arkaan::Utils::MicroService.instance).to receive(:service).and_return(service)

        class NonPremiumTestController < Arkaan::Utils::Controller
          declare_route('get', '/') do
            halt 200, {message: 'test_message'}.to_json
          end
        end
      end

      def app
        NonPremiumTestController.new
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
          get '/', {app_key: 'test_key', token: 'test_token'}, {'sinatra.route' => 'GET /'}
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

        class NonPremiumTestController < Arkaan::Utils::Controller
          declare_route('post', '/') do
            halt 200, {message: 'test_message'}.to_json
          end
        end
      end

      def app
        NonPremiumTestController.new
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
          post '/', {app_key: 'test_key', token: 'test_token'}.to_json, {'sinatra.route' => 'POST /'}
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

  describe :declare_premium_route do

    describe 'When the route does not already exists' do
      before do
        allow(Arkaan::Utils::MicroService.instance).to receive(:service).and_return(service)

        class PremiumTestController < Arkaan::Utils::Controller
          declare_premium_route('get', '/') do
            halt 200, {message: 'test_message'}.to_json
          end
        end
      end

      def app
        PremiumTestController.new
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
          get '/', {app_key: 'test_key', token: 'test_token'}, {'sinatra.route' => 'GET /'}
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

        class PremiumTestController < Arkaan::Utils::Controller
          declare_premium_route('post', '/') do
            halt 200, {message: 'test_message'}.to_json
          end
        end
      end

      def app
        PremiumTestController.new
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
          post '/', {app_key: 'test_key', token: 'test_token'}.to_json, {'sinatra.route' => 'POST /'}
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
end