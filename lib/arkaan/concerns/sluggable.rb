module Arkaan
  module Concerns
    # Includes the slug field, always the same in all models.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Sluggable
      extend ActiveSupport::Concern

      # Module holding the class methods for the classes including this concern.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      module ClassMethods
        # Add the field and its validations in the model including it.
        # @param entity_type [String,Symbol] the name of the model including it, to be included in the error messages.
        def make_sluggable(entity_type)
          # @!attribute [rw] slug
          #   @return [String] the slug of the current entity ; it must be snake-cased, longer than four characters, unique for the entity and given.
          field :slug, type: String

          validates :slug,
            length: {minimum: 4, message: "#{entity_type}.slug.short"},
            format: {with: /\A[a-z]+(_[a-z]+)*\z/, message: "#{entity_type}.slug.format"},
            uniqueness: {message: "#{entity_type}.slug.uniq"},
            presence: {message: "#{entity_type}.slug.blank"}
        end
      end
    end
  end
end