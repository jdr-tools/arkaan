module Arkaan
  module Campaigns
    # A character sheet represents a character played by a player in a campaign.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Character
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] selected
      #   @return [Boolean] TRUE if the sheet is currently selected by the player, FALSE otherwise.
      field :selected, type: Boolean, default: false
      
      # @!attribute [rw] data
      #   @return [Hash] the heart of the Arkaan::Campaigns::Character class, the polymorphic
      #     data representing all the fields of a character sheet are validated using the validator
      #     of the associated plugin, and created/updated with the corresponding form.
      field :data, type: Hash, default: {}

      # @!attribute [rw] invitation
      #   @return [Arkaan::Campaigns::Invitation] the invitation of the player playing this character.
      belongs_to :invitation, class_name: 'Arkaan::Campaigns::Invitation', inverse_of: :characters

      # Returns the player linked to this character.
      # @return [Arkaan::Account] the account of the player incarnating this character.
      def player
        invitation.account
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