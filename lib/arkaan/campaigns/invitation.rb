module Arkaan
  module Campaigns
    # An invitation is the linked between a player and a campaign, accepted or not.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Invitation
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Enumerable

      # @!attribute [rw] status
      #   @return [Symbol] the current status of the invitation.
      enum_field :status, [:accepted, :blocked, :expelled, :ignored, :left, :pending, :refused, :request, :creator], default: :pending

      # @!attribute [rw] account
      #   @return [Arkaan::Account] the account the invitation has been issued to.
      belongs_to :account, class_name: 'Arkaan::Account', inverse_of: :invitations
      # @!attribute [rw] campaign
      #   @return [Arkaan::Campaign] the campaign the invitation has been made in.
      belongs_to :campaign, class_name: 'Arkaan::Campaign', inverse_of: :invitations

      # @!attribute [rw] files
      #   @return [Array<Arkaan::Campaigns::Files::Document>] the files uploaded in this campaign by the user linked to this invitation.
      has_many :permissions, class_name: 'Arkaan::Campaigns::Files::Permission', inverse_of: :invitation
      # @!attribute [rw] characters
      #   @return [Array<Arkaan::Campaigns::Character>] the character sheets for this player.
      has_many :characters, class_name: 'Arkaan::Campaigns::Character', inverse_of: :invitation

      # Gets the currently selected character in a convenient way.
      # @return [Arkaan::Campaigns::Files::Character] the character currently selected by the player.
      def character
        characters.where(selected: true).first
      end

      def documents
        permissions.map(&:document)
      end

      def has_file?(filename)
        return permissions.map(&:document).map(&:name).any? do |name|
          name == filename
        end
      end
    end
  end
end