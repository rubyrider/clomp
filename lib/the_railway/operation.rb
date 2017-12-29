module TheRailway
  class Operation
    attr_accessor :input, :options
    
    def call(tracks: [], mutable_data: {}, immutable_data: {}, options: {})
      @tracks         = tracks
      @mutable_data   = mutable_data
      @immutable_data = immutable_data
      @options        = options
      
      exec_tracks!
    end
    
    def exec_tracks!
      @tracks.each do |track|
        track.exec!(@mutable_data, @immutable_data)
      end
    end
    
    class << self
      attr_accessor :tracks
      
      def add_track(track_name:, &block)
        @tracks ||= []
        
        @tracks << StepBuilder.new(track: track_name, ctx: self, &block)
      end
      
      def call(mutable_data = {}, immutable_data = {}, **options)
        new.call(
            tracks:         @tracks,
            mutable_data:   mutable_data,
            immutable_data: immutable_data,
            options:        options
        )
      end
      
      private
    end
  end
end
