module Arkaan
  module Monitoring
    # An action is made by an authorized user on the instance of a server to perform a task.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Action
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Enumerable

      # @!attribute [rw] type
      #   @return [Symbol] the type of action you're making on this instance
      enum_field :type, [:restart]
      # @!attribute [rw] success
      #   @return [Boolean] TRUE if the action succeeded (or at least was successfully launched), FALSE otherwise.
      field :success, type: Boolean, default: false

      # @!attribute [rw] user
      #   @return [Arkaan::Account] the user performing the action on the instance.
      belongs_to :user, class_name: 'Arkaan::Account'
      # @!attribute [rw] instance
      #   @return [Arkaan::Monitoring::Instance] the instance of a service on which the action is performed.
      embedded_in :instance, class_name: 'Arkaan::Monitoring::Instance', inverse_of: :actions
    end
  end
end