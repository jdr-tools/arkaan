module Arkaan
  module Rulesets
    # A character sheet is the templating to parse and transform an uploaded
    # XML file into a readable character sheet we can display on the interface.
    # The main way to do it is to create attributes sorted into categories (optional)
    # and to link each of these attributes to a XPath selector in the XML sheet
    # the game master uploaded and linked to the player.
    #
    # This way we can just rebuild a JSON object with the categories and fields
    # defined in the sheet, extracted from the XML sheet of the character.
    #
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Sheet
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] ruleset
      #   @return [Arkaan::Ruleset] the set of rules this sheet corresponds to.
      belongs_to :ruleset, class_name: 'Arkaan::Ruleset', inverse_of: :sheet
      # @!attribute [rw] creator
      #   @return [Arkaan::Account] the account of the creator of the sheet.
      belongs_to :creator, class_name: 'Arkaan::Account'
      # @!attribute [rw] categories
      #   @return [Array<Arkaan::Rulesets::Sheets::Category>] the categories declared in this sheet.
      embeds_many :categories, class_name: 'Arkaan::Rulesets::Sheets::Category', inverse_of: :sheet
    end
  end
end