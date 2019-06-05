module Arkaan
  module Utils
    module Plugins
      class Heroku
        # Loads the heroku informations inside the data of the instance.
        # @param instance [Arkaan::Monitoring::Instance] the instance to put the enrichment inside.
        def self.load!(instance)
          if !ENV['OAUTH_TOKEN'].nil? && instance != false && instance.persisted?
            heroku = PlatformAPI.connect_oauth(ENV['OAUTH_TOKEN'])
            regex = /\Ahttps?:\/\/([a-z\-]+).herokuapp.com\/?\z/
            if instance.url.match(regex)
              app_name = instance.url.scan(regex).first.first
              instance.update_attribute(:data, heroku.app.info(app_name))
            end
          end
        end
      end
    end
  end
end