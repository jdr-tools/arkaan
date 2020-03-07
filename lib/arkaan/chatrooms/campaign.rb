module Arkaan
  module Chatrooms
    # Represents the chatroom embedded in a campaign.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Campaign < Arkaan::Chatrooms::Base
      # @!attribute [rw] campaign
      #   @return [Arkaan::Campaign] the campaign the chatroom is linked to.
      embedded_in :campaign, class_name: 'Arkaan::Campaign', inverse_of: :chatroom
    end
  end
end