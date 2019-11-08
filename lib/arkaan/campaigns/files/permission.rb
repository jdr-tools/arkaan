module Arkaan
  module Campaigns
    module Files
      # A file permission is the permission given by the creator of the file to another player to access it.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Permission
        include Mongoid::Document
        include Mongoid::Timestamps
        include Arkaan::Concerns::Enumerable

        # The status of a permission just differenciates the creator and the other players for the moment
        # But it will later be used to give different access rights like read/write
        # @!attribute [rw] status
        #   @return [Symbol] the current level of permission for the linked user on the linked file.
        enum_field :level, [:creator, :read], default: :read

        # @!attribute [rw] invitation
        #   @return [Arkaan::Campaigns::Invitation] the invitation of the player in the campaign where this file was uploaded.
        belongs_to :invitation, class_name: 'Arkaan::Campaigns::Invitation', inverse_of: :permissions
        # @!attribute [rw] file
        #   @return [Arkaan::Campaigns::Files::Document] the file on which the permissions are granted.
        belongs_to :file, class_name: 'Arkaan::Campaigns::Files::Document', inverse_of: :permissions
      end
    end
  end
end