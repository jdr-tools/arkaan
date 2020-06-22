# frozen_string_literal: true

module Arkaan
  module Concerns
    # This module is what I call "a beautiful piece of Ruby engineering"
    # It takes any mongoid field that you may have declared, and historizes
    # it in a dedicated relation if this relation does not already exists.
    #
    # What it does exactly :
    # - Creates the :history relation if it does not already exists.
    # - Creates a method to check for changes of a specific attribute.
    # - Check for changes at initialization to insert the first value.
    # - Check for changes at update/save to store the history.
    #
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Historizable
      extend ActiveSupport::Concern

      # Adds an entry in the history table for the given field.
      # It checks several things to make the history entry valid :
      # - the new value is different from the old value
      # - the old value is identical to the last recorded new value.
      #
      # @param field [String] the name of the field to historize
      # @param from [Any] the old value before update
      # @param to [Any] the new value after update.
      def add_history(field:, from:, to:)
        return if from == to
        return if !history.empty? && history.order_by(:created_at.desc).first.to != from

        event = Arkaan::Event.create(field: field, from: from, to: to, document: self)
        event.save
      end

      # Submodule holding all the static methods add to the current subclass.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      module ClassMethods
        
        # Takes the Mongoid declared field and creates the callbacks
        # to intercept any value change and add it to the history.
        # @field field [Mongoid::Fields::Standard] the Mongoid field to historize.
        def historize(field)

          unless relations.key?('history')
            embeds_many :history, class_name: 'Arkaan::Event'
          end

          after_initialize do |doc|
            add_history(field: field.name, from: nil, to: doc[field.name])
          end

          after_save do |doc|
            if doc.changed_attributes.key?(field.name)
              from = doc.changed_attributes[field.name]
              add_history(field: field.name, from: from, to: doc[field.name])
            end
          end
        end
      end
    end
  end
end
