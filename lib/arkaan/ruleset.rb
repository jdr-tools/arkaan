module Arkaan
  # A set of rules is describing how a specific game system works (eg. Dungeons and Dragons 5th Edition, or Fate)
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Ruleset
    include Mongoid::Document
    include Mongoid::Timestamps

    # @!attribute [rw] name
    #   @return [String] the name of the ruleset (eq. "Dungeons and Dragons 4th Edition")
    field :name, type: String
    # @!attribute [rw] description
    #   @return [String] the complete description of the rule set to quickly have informations on its content.
    field :description, type: String
    # @!attribute [rw] mime_types
    #   @return [Array<String>] a list of MIME types accepted as character sheets MIME types.
    field :mime_types, type: Array, default: []

    # @!attribute [rw] creator
    #   @return [Arkaan::Account] the account of the user creating this ruleset.
    belongs_to :creator, class_name: 'Arkaan::Account', inverse_of: :rulesets
    # @!attribute [rw] blueprints
    #   @return [Arr  ay<Arkaan::Rulesets::Blueprint>] the blueprints created inside this ruleset, see the class itself to know what it is.
    has_many :blueprints, class_name: 'Arkaan::Rulesets::Blueprint', inverse_of: :ruleset
    # @!attribute [rw] campaigns
    #   @return [Array<Arkaan::Campaign>] the campaigns using this set of rules.
    has_many :campaigns, class_name: 'Arkaan::Campaign', inverse_of: :ruleset
    # @!attribute [rw] sheet
    #   @return [Arkaan::Rulesets::Sheet] the character sheet template for this set of rules.
    has_one :sheet, class_name: 'Arkaan::Rulesets::Sheet', inverse_of: :ruleset

    validates :name,
      presence: {message: 'required'},
      length: {minimum: 4, message: 'minlength', if: :name?},
      uniqueness: {message: 'uniq', if: :name?}
  end
end