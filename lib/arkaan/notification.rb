module Arkaan
  # A notification is a little something to warn a user that an action concerning him or her occurred.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Notification
    include Mongoid::Document
    include Mongoid::Timestamps

    # @!attribute [rw] type
    #   @return [String] the type of notification this is supposed to be. All types are custom and facultative.
    field :type, type: String, default: 'NOTIFICATIONS.DEFAULT'
    # @!attribute [rw] read
    #   @return [Boolean] TRUE if the notification has been read (seen by the user), FALSE otherwise.
    field :read, type: Boolean, default: false
    # @!attribute [rw] data
    #   @return [Hash] the custom data that can be attached to this notification, for example for an invitation it can be the invited username.
    field :data, type: Hash, default: {}

    # @!attribute [rw] account
    #   @return [Arkaan::Account] the account concerned by this notification.
    embedded_in :account, class_name: 'Arkaan::Account', inverse_of: :notifications
  end
end