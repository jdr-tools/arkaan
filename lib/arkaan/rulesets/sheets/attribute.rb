module Arkaan
  module Rulesets
    module Sheets
      class Attribute
        include Mongoid::Document
        include Mongoid::Timestamps
        include Arkaan::Concerns::Enumerable

        # @!attribute [rw] name
        #   @return [String] the name of the attribute in the character sheet.
        #     This name is then used in the translation files as a key to retrieve it.
        field :name, type: String, default: ''
        # @!attribute [rw] default
        #   @return [Object] the default value for this attribute. Not typed so it
        #     can be any type of value (mainly integer, strings or datetimes)
        field :default
        # @!attribute [rw] xpath
        #   @return [String] the path to find this attribute in the XML sheet uploaded.
        field :xpath, type: String

        # @!attribute [rw] category
        #   @return [Arkaan::Rulesets::Sheets::Category] the category the attribute is in.
        embedded_in :category, class_name: 'Arkaan::Rulesets::Sheets::Category', inverse_of: :attrs

        validates :name,
          presence: {message: 'required'},
          format: {with: /\A[a-zA-Z_]*\z/, message: 'pattern', if: :name?}

        validate :name_unicity
        
        def name_unicity
          has_duplicate = category.attrs.where(:_id.ne => _id, name: name).exists?
          if name? && category && has_duplicate
            errors.add(:name, 'uniq')
          end
        end
      end
    end
  end
end