module TheRailway
  class Track
    def initialize(track_name: (raise TheRailway::Errors::NoTrackProvided), track_type: :success, mutable_options: TheRailway::Context.new, immutable_options: TheRailway::Context.new, &block)
      @step_name         = track_name # Callable step name
      @step_type         = track_type # Step type, e.g. :success or :failure # default is :success
      @mutable_options   = mutable_options
      @immutable_options = immutable_options || {} # data that can
      @block             = block
    end
  end
end