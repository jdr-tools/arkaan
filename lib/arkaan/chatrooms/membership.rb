module Arkaan
  module Chatrooms
    class Membership
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Enumerable

      enum_field :status, [:shown, :hidden], default: :shown

      belongs_to :chatroom, class_name: 'Arkaan::Chatrooms::Private', inverse_of: :memberships

      belongs_to :account, class_name: 'Arkaan::Account', inverse_of: :memberships
    end
  end
end