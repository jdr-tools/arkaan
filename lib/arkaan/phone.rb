module Arkaan
  # A phone number is given by a user so that the persons he has selected can have it to contact him.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Phone
    include Mongoid::Document
    include Mongoid::Timestamps
    include Arkaan::Concerns::Enumerable

    # @!attribute [rw] privacy
    #   @return [Symbol] the level of privacy you want for this phone number.
    enum_field :privacy, [:players, :public, :private], default: :private
    # @!attribute [rw] number
    #   @return [Integer] the phone number the user has given.
    field :number, type: String

    # @!attribute [rw] account
    #   @return [Arkaan::Account] the account the phone number is associated to.
    embedded_in :account, class_name: 'Arkaan::Account', inverse_of: :phones

    validates :number,
      presence: {message: 'required'},
      format: {with: /\A[0-9\-\._\/]+\z/, message: 'pattern'}
  end
end