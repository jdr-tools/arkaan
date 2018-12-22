module Arkaan
  # A set of rules is describing how a specific game system works (eg. Dungeons and Dragons 5th Edition, or Fate)
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Ruleset
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String

    field :description, type: String

    belongs_to :creator, class_name: 'Arkaan::Account', inverse_of: :rulesets

    validates :name,
      presence: {message: 'required'},
      length: {minimum: 4, message: 'minlength', if: :name?},
      uniqueness: {message: 'uniq', if: :name?}
  end
end