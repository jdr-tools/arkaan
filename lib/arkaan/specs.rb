module Arkaan
  # This module holds all the logic for the specs tools for all micro services (shared examples and other things).
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Specs

    # Includes all the shared examples you could need, describing the basic behaviour of a route.
    def self.include_shared_examples
      RSpec.shared_examples 'a route' do |_verb, _path|
        let(:verb) { _verb }
        let(:path) { _path }

        def do_request(parameters)
          public_send verb.to_sym, path, ['get', 'delete'].include?(verb) ? parameters : parameters.to_json
        end

        describe 'common errors' do
          describe 'bad request errors' do
            describe 'no token error' do
              before do
                do_request({app_key: 'test_key'})
              end
              it 'Raises a bad request (400) error when the parameters don\'t contain the token of the gateway' do
                expect(last_response.status).to be 400
              end
              it 'returns the correct response if the parameters do not contain a gateway token' do
                expect(JSON.parse(last_response.body)).to eq({'message' => 'missing.token'})
              end
            end
            describe 'no application key error' do
              before do
                do_request({token: 'test_token'})
              end
              it 'Raises a bad request (400) error when the parameters don\'t contain the application key' do
                expect(last_response.status).to be 400
              end
              it 'returns the correct response if the parameters do not contain a application key' do
                expect(JSON.parse(last_response.body)).to eq({'message' => 'missing.app_key'})
              end
            end
          end
          describe 'not_found errors' do
            describe 'application not found' do
              before do
                do_request({token: 'test_token', app_key: 'another_key'})
              end
              it 'Raises a not found (404) error when the key doesn\'t belong to any application' do
                expect(last_response.status).to be 404
              end
              it 'returns the correct body when the gateway doesn\'t exist' do
                expect(JSON.parse(last_response.body)).to eq({'message' => 'application_not_found'})
              end
            end
            describe 'gateway not found' do
              before do
                do_request({token: 'other_token', app_key: 'test_key'})
              end
              it 'Raises a not found (404) error when the gateway does\'nt exist' do
                expect(last_response.status).to be 404
              end
              it 'returns the correct body when the gateway doesn\'t exist' do
                expect(JSON.parse(last_response.body)).to eq({'message' => 'gateway_not_found'})
              end
            end
          end
        end
      end
    end
  end
end