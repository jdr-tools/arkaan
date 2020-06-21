# frozen_string_literal: true

module Arkaan
  # An event is symbolizing a timestamped change in a model.
  # It is recommended NOT to use this class directly but to use
  # the Arkaan::Concerns::Historizable concern in a model.
  #
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Event
    include Mongoid::Document
    include Mongoid::Timestamps

    # @!attribute [rw] field
    #   @return [String] the name of the field being historized
    field :field, type: String
    # @!attribute [rw] from
    #   @return [Any] the value of the field before update
    field :from
    # @!attribute [rw] to
    #   @return [Any] the value of the field after update
    field :to

    # @!attribute [rw] document
    #   @return [Any] the model in which the history is embedded
    embedded_in :document, polymorphic: true, inverse_of: :history

    validates :field, presence: { message: 'required' }
  end
end
