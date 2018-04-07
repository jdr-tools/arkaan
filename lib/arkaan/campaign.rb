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

    # @!attribute [rw] creator
    #   @return [Arkaan::Campaign] the account creating the campaign, and considered "game master".
    belongs_to :creator, class_name: 'Arkaan::Account', inverse_of: :campaigns

    # @!attribute [rw] invitations
    #   @return [Array<Arkaan::Campaigns::Invitation>] the invitations to players that have been made for this campaign.
    has_many :invitations, class_name: 'Arkaan::Campaigns::Invitation', inverse_of: :campaign

    validates :title,
      presence: {message: 'required'},
      length: {minimum: 4, message: 'minlength', if: :title?}

    validate :title_unicity

    # Adds an error message if the account creating this campaign already has a campaign with the very same name.
    def title_unicity
      if creator? && title? && creator.campaigns.where(title: title, :id.ne => _id).exists?
        errors.add(:title, 'uniq')
      end
    end
  end
end