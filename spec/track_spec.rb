RSpec.describe Clomp::Track do
  describe 'Track Type' do
    it 'every track has its type' do
      track = Clomp::Track.new(name: 'test')
      expect(track.track?).to be_truthy
      
      track = Clomp::Track.new(name: 'test', right: true)
      expect(track.track?).to be == :right_track
    end
  end
end
