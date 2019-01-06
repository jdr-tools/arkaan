module Arkaan
  module Rulesets
    module Fields
      # An integer field can have a minimum and maximum value.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Integer < Arkaan::Rulesets::Field
        def validate_options
          check_type(:max, 'Integer')
          check_type(:min, 'Integer')
        end
      end
    end
  end
end