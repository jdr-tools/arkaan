# frozen_string_literal: true

module Arkaan
  module Campaigns
    # An invitation is the linked between a player and a campaign.
    # It keeps the history of the interaction between the player and the campaign.
    #
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Invitation
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Enumerable
      include Arkaan::Concerns::Historizable

      # @!attribute [rw] account
      #   @return [Arkaan::Account] the account the invitation has been issued to.
      belongs_to :account, class_name: 'Arkaan::Account', inverse_of: :invitations
      # @!attribute [rw] campaign
      #   @return [Arkaan::Campaign] the campaign the invitation has been made in.
      belongs_to :campaign, class_name: 'Arkaan::Campaign', inverse_of: :invitations

      # @!attribute [rw] status
      #   @return [Symbol] the current status of the invitation.
      historize enum_field :status,
        [:pending, :request, :accepted, :refused, :expelled, :left, :master, :creator],
        default: :pending
    end
  end
end
