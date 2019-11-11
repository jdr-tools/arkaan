module Arkaan
  module Campaigns
    module Files
      # A document is any piece of data added by a user to a campaign. It can either be a direct text note, or an uploaded document for example.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Document
        include Mongoid::Document
        include Mongoid::Timestamps
        include Arkaan::Concerns::MimeTypable
        include Arkaan::Campaigns::Files::Concerns::Nameable
        
        # @!attribute [rw] size
        #   @return [Integer] the size of the document in bytes.
        field :size, type: Integer, default: 0

        mime_type ['image/*', 'text/plain']

        # @!attribute [rw] permission
        #   @return [Arkaan::Campaigns::Permission] the permissions granted to the different users of the campaign concerning this document.
        has_many :permissions, class_name: 'Arkaan::Campaigns::Files::Permission', inverse_of: :document

        # Custom setter for the creator of the document so that it can be used as a normal field.
        # @param invitation [Arkaan::Campaigns::Invitation] the invitation of the player creating this document.
        def creator=(invitation)
          if !permissions.where(invitation: invitation).exists?
            Arkaan::Campaigns::Files::Permission.create(enum_level: :creator, document: self, invitation: invitation)
          end
        end

        # Custom getter for the creator of the campaign.
        # @return [Arkaan::Account] the account of the player that created this document.
        def creator
          return permissions.where(enum_level: :creator).first.invitation.account
        end

        # Checks if an account is allowed to access this document, accounts must have one of the following characteristics to read a document :
        # - Be the creator of the document
        # - Be the game master of the campaign in which the document is declared
        # - Have been granted the permission to access the document
        #
        # @param account [Arkaan::Account] the account trying to access the document.
        # @return [Boolean] TRUE if this account has the right to access the document, FALSe otherwise.
        def is_allowed?(account)
          return true if campaign.creator.id == account.id
          return true if creator.id == account.id
          return true if has_permission?(account)
          return false
        end

        # Checks if the account has the permission to access the designated document.
        # @param account [Arkaan::Account] the account to check the existence of a permission for.
        # @return [Boolean] TRUE if the account has a permission to access this document, FALSE otherwise.
        def has_permission?(account)
          invitation = campaign.invitations.where(account: account).first
          return !invitation.nil? && permissions.where(invitation: invitation).exists?
        end

        def campaign
          permissions.first.invitation.campaign rescue nil
        end
      end
    end
  end
end