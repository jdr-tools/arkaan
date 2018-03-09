module Arkaan
  # This module holds all the logic for the specs tools for all micro services (shared examples and other things).
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Specs

    # Includes all the shared examples you could need, describing the basic behaviour of a route.
    def self.include_shared_examples
      RSpec.shared_examples 'route' do |verb, parameters|

      end
    end
  end
end