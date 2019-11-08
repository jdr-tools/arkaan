module Arkaan
  module Monitoring
    module Results
      # A record is the result of the vigilante asking the health of one instance.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Heartbeat
        include Mongoid::Document

        # @!attribute [rw] status
        #   @return [Integer] the HTTP status of the request made for this record.
        field :status, type: Integer, default: 500
        # @!attribute [rw] body
        #   @return [Hash] the JSON parsed body from the heartbeat request.
        field :body, type: Hash, default: {}
        # @!attribute [rw] healthy
        #   @return [Boolean] TRUE if the instance is deemed healthy, FALSE otherwise.
        field :healthy, type: Boolean, default: false
        # @!attribute [rw] started_at
        #   @return [DateTime] the date at which the heartbeat request has started.
        field :started_at, type: DateTime
        # @!attribute [rw] ended_at
        #   @return [DateTime] the date at which the request was terminated.
        field :ended_at, type: DateTime

        # @!attribute [rw] instance
        #   @return [Arkaan::Monitoring::Instance] the instance on which the record has been done.
        belongs_to :instance, class_name: 'Arkaan::Monitoring::Instance', inverse_of: :heartbeats

        # @!attribute [rw] report
        #   @return [Arkaan::Monitoring::Results::Report] the report made by the vigilante including this record.
        belongs_to :report, class_name: 'Arkaan::Monitoring::Results::Report', inverse_of: :heartbeats

        attr_readonly :healthy

        def status=(status)
          self[:status] = status
          self[:healthy] = status == 200
        end

        def start!
          self.started_at = DateTime.now
        end

        def end!
          self.ended_at = DateTime.now
        end
      end
    end
  end
end