RSpec.describe Clomp::Track do
  describe 'Track Type' do
    it 'every track has its type' do
      track = Clomp::Track.new(name: 'test')
      expect(track.track?).to be_truthy
      
      track = Clomp::Track.new(name: 'test', track_type: :finally)
      expect(track.track?).to be_falsey
      expect(track.finally?).to be_truthy
    end
  end
end
