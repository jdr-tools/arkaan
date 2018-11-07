module Arkaan
  # This module holds the shared concerns to include in the desired models.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Concerns
    autoload :Activable     , 'arkaan/concerns/activable'
    autoload :Diagnosticable, 'arkaan/concerns/diagnosticable'
    autoload :Enumerable    , 'arkaan/concerns/enumerable'
    autoload :MimeTypable   , 'arkaan/concerns/mime_typable'
    autoload :Premiumable   , 'arkaan/concerns/premiumable'
    autoload :Sluggable     , 'arkaan/concerns/sluggable'
    autoload :Typable       , 'arkaan/concerns/typable'
  end
end