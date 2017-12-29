module TheRailway
  class StepBuilder
    attr_reader :track, :ctx, :block, :options
    
    def initialize(track: (raise Errors::NoTrackProvided), ctx:, options: {}, &block)
      @track             = track
      @block             = block
      @ctx               = ctx
      @options           = options
    end
    
    def exec!(mutable_options, immutable_options)
      ctx.send(track.to_sym, mutable_options, immutable_options)
      
      block.call if block.present?
    end
  end
end