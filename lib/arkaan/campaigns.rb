module Arkaan
  # The campaigns module is holding the logic for some objects related to campaigns.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Campaigns
    autoload :Document  , 'arkaan/campaigns/document'
    autoload :File      , 'arkaan/campaigns/file'
    autoload :Files     , 'arkaan/campaigns/files'
    autoload :Invitation, 'arkaan/campaigns/invitation'
    autoload :Message   , 'arkaan/campaigns/message'
    autoload :Note      , 'arkaan/campaigns/note'
    autoload :Tag       , 'arkaan/campaigns/tag'
  end
end