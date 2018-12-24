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

    # @!attribute [rw] creator
    #   @return [Arkaan::Account] the account of the user creating this ruleset.
    belongs_to :creator, class_name: 'Arkaan::Account', inverse_of: :rulesets
    # @!attribute [rw] blueprints
    #   @return [Array<Arkaan::Rulesets::Blueprint>] the blueprints created inside this ruleset, see the class itself to know what it is.
    has_many :blueprints, class_name: 'Arkaan::Rulesets::Blueprint', inverse_of: :ruleset

    validates :name,
      presence: {message: 'required'},
      length: {minimum: 4, message: 'minlength', if: :name?},
      uniqueness: {message: 'uniq', if: :name?}
  end
end