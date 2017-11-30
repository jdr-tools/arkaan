module Arkaan
  # This module holds the shared concerns to include in the desired models.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Concerns
    autoload :Sluggable, 'arkaan/concerns/sluggable'
    autoload :Activable, 'arkaan/concerns/activable'
    autoload :Diagnosticable, 'arkaan/concerns/diagnosticable'
    autoload :Premiumable, 'arkaan/concerns/premiumable'
  end
end