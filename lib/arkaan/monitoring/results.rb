module Arkaan
  module Monitoring
    # The results module handle classes to make results for the vigilante runs.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Results
      autoload :Report, 'arkaan/monitoring/results/report'
      autoload :Heartbeat, 'arkaan/monitoring/results/heartbeat'
    end
  end
end