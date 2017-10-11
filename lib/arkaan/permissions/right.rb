module Arkaan
  module Permissions
    # A right is the access to one or several features in the application. It's applied to a group, and transitively to an account.
    # @author Vincent Courtois <courtois;vincent@outlook.com>
    class Right
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Sluggable

      # @!attribute [rw] groups
      #   @return [Array<Arkaan::Permissions::Group>] the groups granted with the permission to access features opened by this right.
      has_and_belongs_to_many :groups, class_name: 'Arkaan::Permissions::Group', inverse_of: :rights
    end
  end
end