module Arkaan
  module Chatrooms
    class Conversation < Arkaan::Chatrooms::Base
      has_many :memberships, class_name: 'Arkaan::Chatrooms::Membership', inverse_of: :chatroom
    end
  end
end