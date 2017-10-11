module Arkaan
  module Permissions
    # A category of rights regroups one or several rights for convenience purposes.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Category
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Sluggable
    end
  end
end