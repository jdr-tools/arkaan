module Arkaan
  module Files
    # The permission granted to a user to access and/or delete a file.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Permission
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Enumerable

      # @!attribute [rw] type
      #   @return [Symbol] the type of permission granted (is the user able to delete the file ?)
      enum_field :type, [:read, :read_write]

      # @!attribute [rw] file
      #   @return [Arkaan::Files::Document] the document the permission is linked to.
      belongs_to :file, class_name: 'Arkaan::Files::Document', inverse_of: :permissions
      # @!attribute [rw] account
      #   @return [Arkaan::Account] the user being granted the access to the file.
      belongs_to :account, class_name: 'Arkaan::Account', inverse_of: :permissions
    end
  end
end