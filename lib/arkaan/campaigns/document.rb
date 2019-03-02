module Arkaan
  module Campaigns
    # A document is any piece of data added by a user to a campaign. It can either be a direct text note, or an uploaded file for example.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Document
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] permission
      #   @return [Arkaan::Campaigns::Permission] the permissions granted to the different users of the campaign concerning this file.
      has_many :permissions, class_name: 'Arkaan::Campaigns::Files::Permission', inverse_of: :file

      # @!attribute [rw] campaign
      #   @return [Arkaan::Campaign] the campaign in which this file was uploaded.
      belongs_to :campaign, class_name: 'Arkaan::Campaign', inverse_of: :files

      # Custom setter for the creator of the file so that it can be used as a normal field.
      # @param invitation [Arkaan::Campaigns::Invitation] the invitation of the player creating this file.
      def creator=(invitation)
        if !permissions.where(invitation: invitation).exists?
          Arkaan::Campaigns::Files::Permission.create(enum_level: :creator, file: self, invitation: invitation)
        end
      end

      # Custom getter for the creator of the campaign.
      # @return [Arkaan::Account] the account of the player that created this file.
      def creator
        return permissions.where(enum_level: :creator).first.invitation.account
      end

      # Checks if an account is allowed to access this file, accounts must have one of the following characteristics to read a file :
      # - Be the creator of the file
      # - Be the game master of the campaign in which the file is declared
      # - Have been granted the permission to access the file
      #
      # @param account [Arkaan::Account] the account trying to access the file.
      # @return [Boolean] TRUE if this account has the right to access the file, FALSe otherwise.
      def is_allowed?(account)
        return true if campaign.creator.id == account.id
        return true if creator.id == account.id
        return true if has_permission?(account)
        return false
      end

      # Checks if the account has the permission to access the designated file.
      # @param account [Arkaan::Account] the account to check the existence of a permission for.
      # @return [Boolean] TRUE if the account has a permission to access this file, FALSE otherwise.
      def has_permission?(account)
        invitation = campaign.invitations.where(account: account).first
        return !invitation.nil? && permissions.where(invitation: invitation).exists?
      end
    end
  end
end