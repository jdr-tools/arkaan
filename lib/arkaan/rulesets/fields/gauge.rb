module Arkaan
  module Rulesets
    module Fields
      # A gauge is composed of a max value, and a min value, and when instanciated has a current value that can't go above max or below min.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Gauge < Arkaan::Rulesets::Field
        def default_options
          return {initial: 0, max: 100, min: 0, show: true}
        end

        def validate_options
          check_type(:initial, 'Integer')
          check_type(:max, 'Integer')
          check_type(:min, 'Integer')
          check_type(:show, 'Boolean')
        end
      end
    end
  end
end