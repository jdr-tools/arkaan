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

      # Getter for the type of the field, returning simply the last element of the type for simpler use.
      # @return [Symbol] the name of the type of the field (eq :Integer or :Gauge)
      def type
        return _type.split('::').last.to_sym
      end

      # Default options for this type of field, specialize it in the subclasses.
      # @return [Hash] a hash with the default value for all options you want default values on.
      def default_options
        return {}
      end

      # Setter for the additional datas, merging it with the default options for the current type.
      # @param new_data [Hash] the additional data to add to this field.
      def data=(new_data)
        self[:data] = default_options.merge(new_data)
      end

      def name_unicity
        has_duplicate = blueprint._fields.where(:_id.ne => _id, name: name).exists?
        if name? && blueprint && has_duplicate
          errors.add(:name, 'uniq')
        end
      end

      def options_validity
        send(:validate_options) rescue true
      end

      # Checks the corresponding option key against the given data type. All types can be used.
      # @param key [String] the name of the key in the options you want to check the type of.
      # @param required_type [String] the exact name of the class you want to check the option against.
      def check_type(key, required_type)
        parsed_type = Object.const_get("::#{required_type}")
        if !errors.messages.has_key?(:data) && data[key.to_sym] && !data[key.to_sym].is_a?(parsed_type)
          errors.add(:data, "#{key.to_s}|type")
        end
      end
    end
  end
end