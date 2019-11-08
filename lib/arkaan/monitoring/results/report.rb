module Arkaan
  module Monitoring
    module Results
      # A report is the result of one call to the API on one instance status route.
      # @author Vincent Courtois <courtoi.vincent@outlook.com>
      class Report
        include Mongoid::Document
        include Mongoid::Timestamps

        field :started_at, type: DateTime
        # @!attribute [rw] ended_at
        #   @return [DateTime] the timestamp at which the report ends.
        field :ended_at, type: DateTime
        # @!attribute [rw] total
        #   @return [Integer] the total number of services monitored.
        field :total, type: Integer, default: 0
        # @!attribute [rw] healthy
        #   @return [Integer] the number of healthy services amongst all the monitored services.
        field :healthy, type: Integer, default: 0

        # @!attribute [rw] records
        #   @return [Array<Arkaan::Monitoring::Results::Record>] the records linked to this report.
        has_many :heartbeats, class_name: 'Arkaan::Monitoring::Results::Heartbeat', inverse_of: :report
        # @!attribute [rw] vigilante
        #   @return [Arkaan::Monitoring::Vigilante] the vigilante application that has created this report.
        belongs_to :vigilante, class_name: 'Arkaan::Monitoring::Vigilante', inverse_of: :reports

        def add_heartbeat(heartbeat)
          self.heartbeats << heartbeat
          self.total += 1
          self.healthy += (heartbeat.healthy ? 1 : 0)
          heartbeat.end!
        end

        def start!
          self.started_at = DateTime.now
        end

        def end!
          self.ended_at = DateTime.now
          self.save!
        end
      end
    end
  end
end