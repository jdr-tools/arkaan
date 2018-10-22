module Arkaan
  module Campaigns
    # This model represents an in-game tchat message sent in the tchat of a campaign.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Messages

      class Base
        include Mongoid::Document
        include Mongoid::Timestamps

        # @!attribute [rw] campaign
        #   @return [Arkaan::Campaign] the campaign in which the message has been emitted.
        embedded_in :campaign, class_name: 'Arkaan::Campaign', inverse_of: :messages
        # @!attribute [rw] player
        #   @return [Arkaan::Account] the account that has emitted the message in the campaign.
        belongs_to :player, class_name: 'Arkaan::Campaigns::Invitation'
      end
    end
  end
end