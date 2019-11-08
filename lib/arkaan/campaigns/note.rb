module Arkaan
  module Campaigns
    class Note < Arkaan::Campaigns::Document
      field :content, type: String, default: ''
    end
  end
end