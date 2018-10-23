module Arkaan
  # A campaign is a gathering of accounts playing on the same interface, and interacting in a common game.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Campaign
    include Mongoid::Document
    include Mongoid::Timestamps

    # @!attribute [rw] title
    #   @return [String] the title, or name, of the campaign, used to identify it in the list.
    field :title, type: String
    # @!attribute [rw] description
    #   @return [String] a more detailed description, used to give further information about the campaign in general.
    field :description, type: String
    # @!attribute [rw] is_private
    #   @return [Boolean] TRUE if the campaign can be joined only by being invited by the creator, FALSE if it's publicly displayed and accessible.
    field :is_private, type: Boolean, default: true
    # @!attribute [rw] tags
    #   @return [Array<String>] an array of tags describing characteristics of this campaign.
    field :tags, type: Array, default: []
    # @!attributes [rw] max_players
    #   @return [Integer] the maximum number of players allowed in this campaign.
    field :max_players, type: Integer, default: 5

    # @!attribute [rw] invitations
    #   @return [Array<Arkaan::Campaigns::Invitation>] the invitations to players that have been made for this campaign.
    has_many :invitations, class_name: 'Arkaan::Campaigns::Invitation', inverse_of: :campaign

    # @!attribute [rw] messages
    #   @return [Array<Arkaan::Campaigns::Messages::Base>] the messages sent in the chatroom of the campaign.
    embeds_many :messages, class_name: 'Arkaan::Campaigns::Message', inverse_of: :campaign

    validates :title,
      presence: {message: 'required'},
      length: {minimum: 4, message: 'minlength', if: :title?}

    validate :title_unicity

    # Sets the creator of the campaign. This method is mainly used for backward-compatibility needs.
    # @param account [Arkaan::Account] the account of the creator for this campaign.
    def creator=(account)
      if !invitations.where(account: account).exists?
        Arkaan::Campaigns::Invitation.create(campaign: self, account: account, enum_status: :creator)
      end
    end

    # Getter for the creator account of this campaign.
    # @return [Arkaan::Account] the account of the player creating this campaign.
    def creator
      return invitations.where(enum_status: :creator).first.account
    end

    # Adds an error message if the account creating this campaign already has a campaign with the very same name.
    def title_unicity
      # First we take all the other campaign ids of the user.
      campaign_ids = creator.invitations.where(:campaign_id.ne => _id).pluck(:campaign_id)
      # With this list of campaign IDs, we look for a campaign with the same title.
      same_title_campaign = Arkaan::Campaign.where(:_id.in => campaign_ids, title: title)
      if !creator.nil? && title? && same_title_campaign.exists?
        errors.add(:title, 'uniq')
      end
    end
  end
end