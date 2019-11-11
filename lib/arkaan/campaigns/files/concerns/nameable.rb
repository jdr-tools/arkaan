module Arkaan
  module Campaigns
    module Files
      module Concerns
        module Nameable
          extend ActiveSupport::Concern

          included do
            # @!attribute [rw] filename
            #   @return [String] the name of the file, corresponding to the AWS name.
            field :name, type: String

            validates :name, presence: {message: 'required'}
          end
        end
      end
    end
  end
end