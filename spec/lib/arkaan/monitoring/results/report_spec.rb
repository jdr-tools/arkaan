RSpec.describe Arkaan::Monitoring::Results::Report do
  let!(:report_class) { Arkaan::Monitoring::Results::Report }
  let!(:vigilante) { Arkaan::Monitoring::Vigilante.create }

  describe :started_at do
    it 'has no default value at creation' do
      expect(report_class.new(vigilante: vigilante).started_at).to be_nil
    end
    it 'is correctly set when starting the heartbeat' do
      heartbeat = report_class.new(vigilante: vigilante)
      heartbeat.start!
      expect(heartbeat.started_at).to be_a_kind_of(DateTime)
    end
  end
  describe :ended_at do
    it 'has no default value at ending' do
      expect(report_class.new(vigilante: vigilante).ended_at).to be_nil
    end
    it 'is correctly set when terminating the heartbeat' do
      heartbeat = report_class.new(vigilante: vigilante)
      heartbeat.end!
      expect(heartbeat.ended_at).to be_a_kind_of(DateTime)
    end
  end
  describe :total do
    it 'has a default value set at creation' do
      expect(report_class.new(vigilante: vigilante).total).to be 0
    end
    it 'increments when given a new heartbeat' do
      report = report_class.new(vigilante: vigilante)
      report.add_heartbeat(Arkaan::Monitoring::Results::Heartbeat.new)
      expect(report.total).to be 1
    end
  end
  describe :healthy do
    it 'has a default value set at creation' do
      expect(report_class.new(vigilante: vigilante).healthy).to be 0
    end
    it 'increments when given a new healthy heartbeat' do
      report = report_class.new(vigilante: vigilante)
      report.add_heartbeat(Arkaan::Monitoring::Results::Heartbeat.new(status: 200))
      expect(report.healthy).to be 1
    end
    it 'does not increment when given a new unhealthy heartbeat' do
      report = report_class.new(vigilante: vigilante)
      report.add_heartbeat(Arkaan::Monitoring::Results::Heartbeat.new(status: 500))
      expect(report.healthy).to be 0
    end
  end
end