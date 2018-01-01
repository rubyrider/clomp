module TheRailway
  class Operation
    attr_accessor :input, :options
    
    def call(track_builders: [], mutable_data: {}, immutable_data: {})
      @track_builders           = track_builders
      @mutable_data             = mutable_data
      @immutable_data           = immutable_data
      @options                  ||= {}
      @options[:mutable_data]   = mutable_data
      @options[:immutable_data] = immutable_data
      
      exec_steps!
    end
    
    def exec_steps!
      @track_builders.each do |track|
        raise TheRailway::Errors::TrackNotDefined, "Please define track: #{track.name}" unless self.respond_to?(track.name)
        
        track.exec!(self, @options)
      end
      
      self
    end
    
    def steps
      @track_builders.collect { |track| track.name }
    end
    
    class << self
      attr_accessor :track_builders
      
      def add_track(track_name, track_options: {}, &block)
        @track_builders ||= []
        
        @track_builders << Track.new(name: track_name, track_options: track_options, &block)
      end
      
      def call(mutable_data = {}, immutable_data = {})
        self.new.call(
            track_builders: @track_builders,
            mutable_data:   mutable_data,
            immutable_data: immutable_data
        )
      end
    end
  end
end
