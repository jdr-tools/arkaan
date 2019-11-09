module Arkaan
  module Rulesets
    module Sheets
      # A category is just a semantic group of attributes having the same function
      # or sharing some semantic proximity (eg. all characteristics or skills).
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Category
        include Mongoid::Document
        include Mongoid::Timestamps

        # @!attribute [rw] name
        #   @return [String] the name of the category you're creating.
        field :name, type: String, default: ''

        # @!attribute [rw] sheet
        #   @return [Arkaan::Rulesets::Sheet] the sheet template the category is embedded in; 
        embedded_in :sheet, class_name: 'Arkaan::Rulesets::Sheet', inverse_of: :categories

        # @!attribute [rw] attributes
        #   @return [Array<Arkaan::Rulesets::Sheets::Attribute>] the attributes linked to this category.
        embeds_many :attrs, class_name: 'Arkaan::Rulesets::Sheets::Attribute', inverse_of: :category
      end
    end
  end
end