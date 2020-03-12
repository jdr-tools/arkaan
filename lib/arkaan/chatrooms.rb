module Arkaan
  # The chatrooms modules regroup all classes concerning messages between players.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Chatrooms
    autoload :Base        , 'arkaan/chatrooms/base'
    autoload :Campaign    , 'arkaan/chatrooms/campaign'
    autoload :Conversation, 'arkaan/chatrooms/conversation'
    autoload :Message     , 'arkaan/chatrooms/message'
    autoload :Membership  , 'arkaan/chatrooms/membership'
  end
end