module Arkaan
  # This module holds the logic for the connection of an application to our API.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module OAuth
    autoload :Application  , 'arkaan/oauth/application'
    autoload :Authorization, 'arkaan/oauth/authorization'
    autoload :AccessToken  , 'arkaan/oauth/access_token'
  end
end