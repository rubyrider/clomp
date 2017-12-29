module TheRailway
  class StepBuilder
    def initialize(track: (raise Errors::NoTrackProvided), ctx:, &block)
      @track             = track
      @block             = block
      @ctx               = ctx
    end
    
    def exec!(mutable_options, immutable_options)
      @ctx.send(@track.to_sym, mutable_options, immutable_options)
      
      @block.call if @block.present?
    end
  end
end