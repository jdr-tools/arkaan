module Arkaan
  module Campaigns
    # This model represents an in-game tchat message sent in the tchat of a campaign.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Messages

      class Diceroll < Arkaan::Campaigns::Messages::Base

        # @!attribute [rw] number_of_dices
        #   @return [Integer] the number of dices you want to roll.
        field :number_of_dices, type: Integer, default: 1
        # @!attribute [rw] number_of_faces
        #   @return [Integer] the number of faces each dice is supposed to have.
        field :number_of_faces, type: Integer, default: 20
        # @!attribute [rw] modifier
        #   @return [Integer] the value added to the sum of all dices to get the final result.
        field :modifier, type: Integer, default: 0
      end
    end
  end
end