module Arkaan
  module Authentication
    class Session
      include Mongoid::Document
      include Mongoid::Timestamps

      field :token, type: String

      field :expiration, type: Integer, default: 0

      belongs_to :account, class_name: 'Arkaan::Account', inverse_of: :sessions

      validates :token,
        presence: {message: 'session.token.blank'},
        uniqueness: {message: 'session.token.uniq', if: :token?},
        length: {minimum: 10, message: 'session.token.short', if: :token?}

      validates :expiration,
        presence: {message: 'session.expiration.blank'}
    end
  end
end