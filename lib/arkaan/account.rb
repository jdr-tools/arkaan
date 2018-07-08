module Arkaan
  # A user account with all related attributes. It holds credentials and informations about a designated user.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Account
    include Mongoid::Document
    include Mongoid::Timestamps
    include ActiveModel::SecurePassword

    # @!attribute [rw] username
    #   @return [String] the nickname the user chose at subscription, must be given, unique, and 6 or more characters long.
    field :username, type: String
    # @!attribute [r] password_digest
    #   @return [String] the password of the user, encrypted with the Blowfish algorithm.
    field :password_digest, type: String
    # @!attribute [rw] lastname
    #   @return [String] the last name (family name) of the user.
    field :lastname, type: String, default: ''
    # @!attribute [rw] firstname
    #   @return [String] the first name of the user.
    field :firstname, type: String, default: ''
    # @!attribute [rw] email
    #   @return [String] the email address of the user, useful to contact them ; it must be given, unique, and have an email format.
    field :email, type: String

    # @!attribute [w] password
    #   @return [String] password, in clear, of the user ; do not attempt to get the value, just set it when changing the password.
    # @!attribute [w] password_confirmation
    #   @return [String] the confirmation of the password, do not get, just set it ; it must be the same as the password.
    has_secure_password validations: false

    # @!attribute [rw] groups
    #   @return [Array<Arkaan::Permissions::Group>] the groups giving their corresponding rights to the current account.
    has_and_belongs_to_many :groups, class_name: 'Arkaan::Permissions::Group', inverse_of: :accounts
    
    # @!attribute [rw] applications
    #   @return [Array<Arkaan::OAuth::Application] the applications this user has created and owns.
    has_many :applications, class_name: 'Arkaan::OAuth::Application', inverse_of: :creator
    # @!attribute [rw] authorizations
    #   @return [Array<Arkaan::OAuth::Authorization>] the authorization issued by this account to third-party applications to access its data.
    has_many :authorizations, class_name: 'Arkaan::OAuth::Authorization', inverse_of: :account
    # @!attribute [rw] services
    #   @return [Array<Arkaan::Monitoring::Service>] the services created by this user.
    has_many :services, class_name: 'Arkaan::Monitoring::Service', inverse_of: :creator
    # @!attribute [rw] sessions
    #   @return [Array<Arkaan::Authentication::Session>] the sessions on which this account is, or has been logged in.
    has_many :sessions, class_name: 'Arkaan::Authentication::Session', inverse_of: :account
    # @!attribute [rw] campaigns
    #   @return [Array<Arkaan::Campaign>] the campaigns this account has created.
    has_many :campaigns, class_name: 'Arkaan::Campaign', inverse_of: :creator
    # @!attribute [rw] invitations
    #   @return [Array<Arkaan::Campaigns::Invitation>] the invitations in campaigns you have been issued.
    has_many :invitations, class_name: 'Arkaan::Campaigns::Invitation', inverse_of: :account
    # @!attribute [rw] invitations
    #   @return [Array<Arkaan::Campaigns::Invitation>] the invitations you've issued yourself to other players.
    has_many :created_invitations, class_name: 'Arkaan::Campaigns::Invitation', inverse_of: :creator
    # @!attribute [rw] websockets
    #   @return [Array<Arkaan::Monitoring::Websocket>] the websockets created by the owner of this account.
    has_many :websockets, class_name: 'Arkaan::Monitoring::Websocket', inverse_of: :creator

    # @!attribute [rw] phones
    #   @return [Array<Arkaan::Phone>] the phone numbers given by the user.
    embeds_many :phones, class_name: 'Arkaan::Phone', inverse_of: :account

    validates :username,
      presence: {message: 'required'},
      length: {minimum: 6, message: 'minlength', if: :username?},
      uniqueness: {message: 'uniq', if: :username?}

    validates :email,
      presence: {message: 'required'},
      format: {with: /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/, message: 'pattern', if: :email?},
      uniqueness: {message: 'uniq', if: :email?}

    validates :password,
      presence: {message: 'required', if: ->{ !persisted? || password_digest_changed? }},
      confirmation: {message: 'confirmation', if: :password_digest_changed?}

    validates :password_confirmation,
      presence: {message: 'required', if: :password_digest_changed?}
  end
end