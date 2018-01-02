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
    
    # Execute all the steps! Execute all the tracks!
    def exec_steps!
      @track_builders.each do |track|
        raise Errors::TrackNotDefined, "Please define track: #{track.name}" unless self.respond_to?(track.name)
        
        _track = track.exec!(self, @options)
        
        break if _track.failure?
      end
      
      @result = Result.new(@options, @track_builders, self)
    end
    
    def executed_steps
      @track_builders.collect { |track| track.name if track.success? }.compact
    end
    
    # Name of the steps defined in the operation class
    def steps
      @track_builders.collect { |track| track.name }
    end
    
    class << self
      
      # To store and read all the tracks!
      attr_accessor :track_builders
      
      # get track name and options!
      def track(track_name, track_options: {}, &block)
        @track_builders ||= []
        
        @track_builders << build_track(track_name, track_options, :track, &block)
      end

      # get the track name for the failure case!
      def failure(track_name, track_options: {}, &block)
        @track_builders ||= []
        
        @track_builders << build_track(track_name, track_options, :failed_track, &block)
      end

      # get the track name for the final step! Only one step will be executed!
      def finally(track_name, track_options: {}, &block)
        @track_builders ||= []
  
        @track_builders << build_track(track_name, track_options, :finally, &block)
      end
      
      def call(mutable_data = {}, immutable_data = {})
        self.new.call(
            track_builders: @track_builders,
            mutable_data:   mutable_data,
            immutable_data: immutable_data
        )
      end
      
      private
      
      def build_track(track_name, track_options = {}, track_type , &block)
        Track.new(name: track_name, track_options: track_options, track_type: track_type, &block)
      end
    end
  end
end
