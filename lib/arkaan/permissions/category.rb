module Arkaan
  module Permissions
    # A category of rights regroups one or several rights for convenience purposes.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Category
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Sluggable

      has_many :rights, class_name: 'Arkaan::Permissions::Right', inverse_of: :category

      make_sluggable 'category'
    end
  end
end