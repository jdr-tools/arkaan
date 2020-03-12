module Arkaan
  module Chatrooms
    # The base chatroom class, made to be subclassed in campaign and personal chatrooms.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Base
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] messages
      #   @return [Array<Arkaan::Chatrooms::Message>] the messages sent in this chatroom.
      has_many :messages, class_name: 'Arkaan::Chatrooms::Message', inverse_of: :chatroom
    end
  end
end