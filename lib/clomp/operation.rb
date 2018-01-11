module Clomp
  class Operation
    attr_reader :result
    
    # Constructor for operation object
    #
    # @param track_builders [Array] the list of tracks we define
    # @param options [Hash] of options to be provided by .[] call/method
    # @return [self]
    def initialize(track_builders: [], options: {})
      @options = options
      # Setup result object!
      @result = Result.new(
          operation: self,
          tracks:    track_builders || [],
          options:   options || {}
      )
      
      exec_steps!(@result)
    end
    
    # Execute all the steps! Execute all the tracks!
    def exec_steps!(result)
      result['tracks'].each do |track|
        next unless track.track?
        raise Errors::TrackNotDefined, "Please define the track in your operation/service: #{track.name}" unless self.respond_to?(track.name)
        
        _track = track.exec!(self, @options)
        
        break if _track.failure?
      end
      
      self
    end
    
    def executed_steps
      @result['tracks'].collect {|track| track.name if track.success?}.compact
    end
    
    # Name of the steps defined in the operation class
    def steps
      @result['tracks'].collect {|track| track.name}
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
      
      def [](mutable_data = {}, immutable_data = {})
        self.(mutable_data, immutable_data)
      end
      
      def call(mutable_data = {}, immutable_data = {})
        new(
            track_builders: @track_builders,
            options: {
                mutable_data:   mutable_data,
                immutable_data: immutable_data
            },
        ).result
      end
      
      private
      
      def build_track(track_name, track_options = {}, track_type, &block)
        Track.new(name: track_name, track_options: track_options, track_type: track_type, &block)
      end
    end
  end
end
