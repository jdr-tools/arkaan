module Arkaan
  module Utils
    # Module gathering all the exception classes used throughout the utils module, mainly linked to HTTP errors.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Errors
      autoload :BadRequest, 'arkaan/utils/errors/bad_request'
      autoload :Forbidden , 'arkaan/utils/errors/forbidden'
      autoload :NotFound  , 'arkaan/utils/errors/not_found'
      autoload :HTTPError , 'arkaan/utils/errors/http_error'
    end
  end
end