module Arkaan
  module Campaigns
    module Files
      class Note < Arkaan::Campaigns::Files::Base
        field :content, type: String, default: ''
      end
    end
  end
end