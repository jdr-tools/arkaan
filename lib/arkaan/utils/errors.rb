module Arkaan
  module Utils
    module Errors
      autoload :BadRequest, 'arkaan/utils/errors/bad_request'
      autoload :Forbidden , 'arkaan/utils/errors/forbidden'
      autoload :NotFound  , 'arkaan/utils/errors/not_found'
    end
  end
end