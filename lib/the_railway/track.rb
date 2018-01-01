module TheRailway
  class Track
    attr_reader :name, :block, :track_options
    
    def initialize(name: (raise Errors::NoTrackProvided), track_options: {}, &block)
      @name          = name
      @block         = block
      @track_options = track_options
    end
    
    def exec!(object, options)
      if object.method(name.to_sym).arity > 1
        object.public_send(name.to_sym, options, **options)
      else
        object.public_send(name.to_sym, options)
      end
      
      @block.call if @block
    end
  end
end