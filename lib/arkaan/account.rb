module Arkaan
  class Account
    include Mongoid::Document
    include Mongoid::Timestamps
    include ActiveModel::SecurePassword

    field :username, type: String

    field :password_digest, type: String

    validates :username, length: {minimum: 6}, uniqueness: true

    has_secure_password
  end
end