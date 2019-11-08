RSpec.describe Arkaan::Monitoring::Results::Heartbeat do

  let!(:heartbeat_class) { Arkaan::Monitoring::Results::Heartbeat }

  describe :healthy do
    it 'has a default value set at creation' do
      expect(heartbeat_class.new.healthy).to be false
    end
    it 'is automatically set up when setting the status at 200' do
      expect(heartbeat_class.new(status: 200).healthy).to be true
    end
    it 'is automatically set up when setting the status with another value' do
      expect(heartbeat_class.new(status: 500).healthy).to be false
    end
  end
  describe :status do
    it 'has a default value set at creation' do
      expect(heartbeat_class.new.status).to be 500
    end
    it 'returns the correct value' do
      expect(heartbeat_class.new(status: 200).status).to be 200
    end
  end
  describe :body do
    it 'has a default value set a creation' do
      expect(heartbeat_class.new.body).to eq({})
    end
    it 'returns the correct value' do
      expect(heartbeat_class.new(body: {foo: 'bar'}).body).to eq({foo: 'bar'})
    end
  end
  describe :started_at do
    it 'has no default value at creation' do
      expect(heartbeat_class.new.started_at).to be_nil
    end
    it 'is correctly set when starting the heartbeat' do
      heartbeat = heartbeat_class.new
      heartbeat.start!
      expect(heartbeat.started_at).to be_a_kind_of(DateTime)
    end
  end
  describe :ended_at do
    it 'has no default value at ending' do
      expect(heartbeat_class.new.ended_at).to be_nil
    end
    it 'is correctly set when terminating the heartbeat' do
      heartbeat = heartbeat_class.new
      heartbeat.end!
      expect(heartbeat.ended_at).to be_a_kind_of(DateTime)
    end
  end
end