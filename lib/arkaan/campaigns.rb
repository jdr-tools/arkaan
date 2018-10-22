module Arkaan
  # The campaigns module is holding the logic for some objects related to campaigns.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Campaigns
    autoload :Invitation, 'arkaan/campaigns/invitation'
    autoload :Messages  , 'arkaan/campaigns/messages'
    autoload :Tag       , 'arkaan/campaigns/tag'
  end
end