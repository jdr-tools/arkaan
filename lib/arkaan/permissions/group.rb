module Arkaan
  module Permissions
    # A group gathers one or several users to give them the same rights for conviniency purposes.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Group
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Sluggable

      # @!attribute [rw] is_default
      #   @return [Boolean] a boolean indicating whether this group is given when a new user registered or not.
      field :is_default, type: Boolean, default: false

      # @!attribute [rw] accounts
      #   @return [Array<Arkaan::Account>] the accounts having the rights granted by this group.
      has_and_belongs_to_many :accounts, class_name: 'Arkaan::Account', inverse_of: :groups
      # @!attribute [rw] rights
      #   @return [Array<Arkaan::Permissions::Right>] the rights granted by belonging to this group.
      has_and_belongs_to_many :rights, class_name: 'Arkaan::Permissions::Right', inverse_of: :groups
      # @!attribute [rw] routes
      #   @return [Array<Arkaan::Monitoring::Route>] the routes this group can access in the API.
      has_and_belongs_to_many :routes, class_name: 'Arkaan::Monitoring::Route', inverse_of: :groups

      make_sluggable 'group'
    end
  end
end