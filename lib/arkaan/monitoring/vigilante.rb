module Arkaan
  module Monitoring
    # A vigilante is a specific type of service that watches over the
    # infrastructure and give a clear look at its global state.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Vigilante < Arkaan::Monitoring::Service

      # @!attribute [rw] token
      #   @return [String] the token the vigilante uses to identify himself in the services
      field :token, type: String

      validates :token, presence: {message: 'required'}
    end
  end
end