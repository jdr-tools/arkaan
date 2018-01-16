class TestController < Arkaan::Utils::Controller
  get '/' do
    halt 200, {message: 'test_message'}.to_json
  end
  post '/' do
    halt 201, {message: 'created'}.to_json
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
    describe 'Nominal case' do
      before do
        get '/', {app_key: 'test_key', token: 'test_token'}
      end
      it 'correctly calls the route when all parameters are rightly given' do
        expect(last_response.status).to be 200
      end
      it 'returns the correct body for the nominal case' do
        expect(JSON.parse(last_response.body)).to eq({'message' => 'test_message'})
      end
    end
    describe 'Bad request errors' do
      describe 'Empty body error' do
        before do
          get '/', {}
        end
        it 'Returns a Bad Request (400) error if the body is empty' do
          expect(last_response.status).to be 400
        end
        it 'Returns the right error message if the body is empty' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'bad_request'})
        end
      end
      describe 'No gateway token error' do
        before do
          get '/', {app_key: 'test_key'}
        end
        it 'Returns a Bad Request (400) error if the gateway token is not given' do
          expect(last_response.status).to be 400
        end
        it 'Returns the right error message if the gateway token is not given' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'bad_request'})
        end
      end
      describe 'No application key error' do
        before do
          get '/', {token: 'test_token'}
        end
        it 'Returns a Bad Request (400) error if the application key is not given' do
          expect(last_response.status).to be 400
        end
        it 'Returns the right error message if the application key is not given' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'bad_request'})
        end
      end
    end
    describe 'Unauthorized errors' do
      describe 'Application not premium error' do
        before do
          get '/', {app_key: 'other_key', token: 'test_token'}
        end
        it 'Returns an unauthorized (401) error if the application is not premium' do
          expect(last_response.status).to be 401
        end
        it 'Returns the right error message if the application is not premium' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'application_not_authorized'})
        end
      end
    end
    describe 'Not found errors' do
      describe 'Gateway not found error' do
        before do
          get '/', {app_key: 'other_key', token: 'wrong_token'}
        end
        it 'Returns a Not Found (404) error if the gateway does not exist' do
          expect(last_response.status).to be 404
        end
        it 'Returns the right error message if the gateway does not exist' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'gateway_not_found'})
        end
      end
      describe 'Application not found error' do
        before do
          get '/', {app_key: 'wrong_key', token: 'test_token'}
        end
        it 'Returns a Not Found (404) error if the application does not exist' do
          expect(last_response.status).to be 404
        end
        it 'Returns the right error message if the application does not exist' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'application_not_found'})
        end
      end
    end
  end

  describe 'POST request' do
    describe 'Nominal case' do
      before do
        post '/', {app_key: 'test_key', token: 'test_token'}.to_json
      end
      it 'correctly calls the route when all parameters are rightly given' do
        expect(last_response.status).to be 201
      end
      it 'returns the correct body for the nominal case' do
        expect(JSON.parse(last_response.body)).to eq({'message' => 'created'})
      end
    end
    describe 'Bad request errors' do
      describe 'Empty body error' do
        before do
          post '/', {}.to_json
        end
        it 'Returns a Bad Request (400) error if the body is empty' do
          expect(last_response.status).to be 400
        end
        it 'Returns the right error message if the body is empty' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'bad_request'})
        end
      end
      describe 'No gateway token error' do
        before do
          post '/', {app_key: 'test_key'}.to_json
        end
        it 'Returns a Bad Request (400) error if the gateway token is not given' do
          expect(last_response.status).to be 400
        end
        it 'Returns the right error message if the gateway token is not given' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'bad_request'})
        end
      end
      describe 'No application key error' do
        before do
          post '/', {token: 'test_token'}.to_json
        end
        it 'Returns a Bad Request (400) error if the application key is not given' do
          expect(last_response.status).to be 400
        end
        it 'Returns the right error message if the application key is not given' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'bad_request'})
        end
      end
    end
    describe 'Unauthorized errors' do
      describe 'Application not premium error' do
        before do
          post '/', {app_key: 'other_key', token: 'test_token'}.to_json
        end
        it 'Returns an unauthorized (401) error if the application is not premium' do
          expect(last_response.status).to be 401
        end
        it 'Returns the right error message if the application is not premium' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'application_not_authorized'})
        end
      end
    end
    describe 'Not found errors' do
      describe 'Gateway not found error' do
        before do
          post '/', {app_key: 'other_key', token: 'wrong_token'}.to_json
        end
        it 'Returns a Not Found (404) error if the gateway does not exist' do
          expect(last_response.status).to be 404
        end
        it 'Returns the right error message if the gateway does not exist' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'gateway_not_found'})
        end
      end
      describe 'Application not found error' do
        before do
          post '/', {app_key: 'wrong_key', token: 'test_token'}.to_json
        end
        it 'Returns a Not Found (404) error if the application does not exist' do
          expect(last_response.status).to be 404
        end
        it 'Returns the right error message if the application does not exist' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'application_not_found'})
        end
      end
    end
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
          get '/', {app_key: 'test_key', token: 'test_token'}
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
          post '/', {app_key: 'test_key', token: 'test_token'}.to_json
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
          get '/', {app_key: 'test_key', token: 'test_token'}
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
          post '/', {app_key: 'test_key', token: 'test_token'}.to_json
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