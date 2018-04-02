module Arkaan
  module Campaigns
    # An invitation is the linked between a player and a campaign, accepted or not.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Invitation
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] accepted
      #   @return [Boolean] TRUE if the invitation has been accepted, false otherwise.
      field :accepted, type: Boolean, default: false
      # @!attribute [rw] accepted_at
      #   @return [DateTime] the date at which the invitation has been accepted.
      field :accepted_at, type: DateTime, default: nil

      # @!attribute [rw] account
      #   @return [Arkaan::Account] the account the invitation has been issued to.
      belongs_to :account, class_name: 'Arkaan::Account', inverse_of: :invitations
      # @!attribute [rw] campaign
      #   @return [Arkaan::Campaign] the campaign the invitation has been made in.
      belongs_to :campaign, class_name: 'Arkaan::Campaign', inverse_of: :invitations
      # @!attribute [rw] creator
      #   @return [Arkaan::Account] the account creating the invitation.
      belongs_to :creator, class_name: 'Arkaan::Account', inverse_of: :created_invitations
    end
  end
end