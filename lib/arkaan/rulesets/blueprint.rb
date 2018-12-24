module Arkaan
  module Rulesets
    # A blueprint defines what a type of entity contains.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Blueprint
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] name
      #   @return [String] the name of this type of entity in the ruleset.
      field :name, type: String

      # @!attribute [rw] ruleset
      #   @return [Arkaan::Ruleset] the ruleset to which this blueprint belongs.
      belongs_to :ruleset, class_name: 'Arkaan::Ruleset', inverse_of: :blueprints
      # @!attribute [rw] _fields
      #   @return [Array<Arkaan::Rulesets::Field>] the field composing the attributes of this blueprint.
      embeds_many :_fields, class_name: 'Arkaan::Rulesets::Field', inverse_of: :blueprint

      validates :name,
        presence: {message: 'required'},
        length: {minimum: 4, message: 'minlength', if: :name?}

      validate :name_unicity

      def name_unicity
        has_duplicate = ruleset.blueprints.where(:_id.ne => _id, name: name).exists?
        if !ruleset.nil? && name? && has_duplicate
          errors.add(:name, 'uniq')
        end
      end
    end
  end
end