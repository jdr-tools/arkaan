module Arkaan
  # This module holds the logic for all the classes concerning the permissions abd rights for the user.
  # A permission is restricting the access to one or several features to the users having it.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Permissions
    autoload :Right   , 'arkaan/permissions/right'
    autoload :Group   , 'arkaan/permissions/group'
    autoload :Category, 'arkaan/permissions/category'
  end
end