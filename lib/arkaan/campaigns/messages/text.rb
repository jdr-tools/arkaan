module Arkaan
  module Campaigns
    # This model represents an in-game tchat message sent in the tchat of a campaign.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Messages

      class Text < Arkaan::Campaigns::Messages::Base

        # @!attribute [rw] content
        #   @return [String] the content of the message as raw text.
        field :content, type: String
      end
    end
  end
end