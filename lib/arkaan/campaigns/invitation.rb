module Arkaan
  module Campaigns
    # An invitation is the linked between a player and a campaign, accepted or not.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Invitation
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Enumerable

      # @!attribute [rw] status
      #   @return [Symbol] the current status of the invitation.
      enum_field :status, [:accepted, :expelled, :ignored, :pending, :refused], default: :pending

      # @!attribute [rw] account
      #   @return [Arkaan::Account] the account the invitation has been issued to.
      belongs_to :account, class_name: 'Arkaan::Account', inverse_of: :invitations
      # @!attribute [rw] campaign
      #   @return [Arkaan::Campaign] the campaign the invitation has been made in.
      belongs_to :campaign, class_name: 'Arkaan::Campaign', inverse_of: :invitations
    end
  end
end