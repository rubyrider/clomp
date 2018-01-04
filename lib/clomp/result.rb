module Clomp
  class Result
    include CommonStates
    extend Forwardable
    
    attr_reader :options, :state, :operation
    
    def_delegators :@operation, :steps, :executed_steps
    
    def initialize(options, tracks = [], operation)
      @options   = options
      @tracks    = tracks
      @error     = nil
      @state     = @tracks.select {|track| track.failure?}.count.zero? ? SUCCESS : FAILURE
      @operation = operation
    end
  end
end