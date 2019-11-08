module Arkaan
  module Campaigns
    # This model represents an in-game tchat message sent in the tchat of a campaign.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Message
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Enumerable

      # @!attribute [rw] type
      #  @return [Symbol] the type of message (plain text or command) contained in the data, used to parse and display it.
      enum_field :type, [:text, :command], default: :text
      # @!attribute [rw] data
      #   @return [Hash] the additional data passed to the message (arguments of the command, or content of the text)
      field :data, type: Hash, default: {}
      # @!attribute [rw] deleted
      #   @return [Boolean] TRUE if the message has been marked as deleted by its user, FALSE otherwise.
      field :deleted, type: Boolean, default: false

      # @!attribute [rw] campaign
      #   @return [Arkaan::Campaign] the campaign in which the message has been emitted.
      embedded_in :campaign, class_name: 'Arkaan::Campaign', inverse_of: :messages
      # @!attribute [rw] player
      #   @return [Arkaan::Account] the account that has emitted the message in the campaign.
      belongs_to :player, class_name: 'Arkaan::Campaigns::Invitation'
    end
  end
end