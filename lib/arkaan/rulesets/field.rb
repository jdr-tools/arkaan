module Arkaan
  module Rulesets
    # A field is an attribute of a blueprint, with a type and a name.
    # It does not have a defined value as it will be given in the instance of the blueprint.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Field
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Enumerable

      # @!attribute [rw] name
      #   @return [String] the name of the field is comparable to the name of a variable.
      field :name, type: String
      # @!attribute [rw] type
      #   @return [Symbol] the type of the field, in a pre-defined list of available types.
      enum_field :type, [:DateTime, :Gauge, :Integer, :String], default: :Integer
      # @!attribute [rw] data
      #   @return [Hash] the additional data, mainly constraints and needed values, for the field.
      field :data, type: Hash, default: {}

      # @!attribute [rw] blueprint
      #   @return [Arkaan::Rulesets::Blueprint] the blueprint in which the field belongs.
      embedded_in :blueprint, class_name: 'Arkaan::Rulesets::Blueprint', inverse_of: :_fields

      validates :name,
        presence: {message: 'required'},
        length: {minimum: 4, message: 'minlength', if: :name?},
        format: {with: /\A[a-zA-Z_]*\z/, message: 'pattern', if: :name?}

      validate :name_unicity

      validate :options_validity

      def data=(new_data)
        default_options = send :"default_#{type.downcase}_options" rescue {}
        self[:data] = default_options.merge(new_data)
      end

      def name_unicity
        has_duplicate = blueprint._fields.where(:_id.ne => _id, name: name).exists?
        if name? && blueprint && has_duplicate
          errors.add(:name, 'uniq')
        end
      end

      def options_validity
        method_name = :"validate_#{type.downcase}_options"
        send method_name if respond_to? method_name
      end

      def validate_gauge_options
        if data[:max] && !data[:max].is_a?(Integer)
          errors.add(:data, 'max|type')
        end
        if data[:initial] && !data[:initial].is_a?(Integer)
          errors.add(:data, 'initial|type')
        end
        if data[:show] && !data[:show].is_a?(Boolean)
          errors.add(:data, 'show|type')
        end
      end

      def default_gauge_options
        return {max: 100, initial: 0, show: true}
      end
    end
  end
end