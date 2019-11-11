module Arkaan
  module Campaigns
    # A character sheet represents a character played by a player in a campaign.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Character
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::MimeTypable
      include Arkaan::Campaigns::Files::Concerns::Nameable

      # @!attribute [rw] selected
      #   @return [Boolean] TRUE if the sheet is currently selected by the player, FALSE otherwise.
      field :selected, type: Boolean, default: false
      # @!attribute [rw] mime_type
      #   @return [String] the mime_type of the character sheet, MUST be an authorized MIME type for
      #     the ruleset the campaign is set to be in.
      mime_type :available_mime_types

      # @!attribute [rw] invitation
      #   @return [Arkaan::Campaigns::Invitation] the invitation of the player playing this character.
      belongs_to :invitation, class_name: 'Arkaan::Campaigns::Invitation', inverse_of: :characters

      # Returns the player linked to this character.
      # @return [Arkaan::Account] the account of the player incarnating this character.
      def player
        invitation.account
      end

      # Method used to dinamically determine what MIME types are allowed for this character sheet
      # If the campaign this character is in has no ruleset, every MIME type is allowed.
      # @return [Array<String>] the available MIME type for the campaign linked to this character.
      def available_mime_types
        invitation.campaign.ruleset.mime_types
      end

      def campaign
        invitation.campaign
      end

      # Puts the selected flag to TRUE for this character and to FALSE for all the
      # other characters for the same player in the same campaign.
      def select!
        invitation.characters.each do |character|
          character.update_attribute(:selected, false)
          character.save!
        end
        update_attribute(:selected, true)
        save!
      end
    end
  end
end