module Arkaan
  module Campaigns
    module Files
      # A character sheet represents a character played by a player in a campaign.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Character < Arkaan::Campaigns::Files::Base
        include Arkaan::Campaigns::Files::Concerns::Nameable

        # @!attribute [rw] selected
        #   @return [Boolean] TRUE if the sheet is currently selected by the player, FALSE otherwise.
        field :selected, type: Boolean, default: false

        # @!attribute [rw] invitation
        #   @return [Arkaan::Campaigns::Invitation] the invitation of the player playing this character.
        belongs_to :invitation, class_name: 'Arkaan::Campaigns::Invitation', inverse_of: :characters

        # Returns the player linked to this character.
        # @return [Arkaan::Account] the account of the player incarnating this character.
        def player
          invitation.account
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
end