module TheRailway
  class Track
    attr_reader :name, :block, :track_options
    
    VALID_TRACK_TYPES = %I(track failed_track finally)
    
    def initialize(name: (raise Errors::NoTrackProvided), track_options: {}, track_type: VALID_TRACK_TYPES.first, &block)
      raise UnknownTrackType, 'Please provide a valid track type' unless VALID_TRACK_TYPES.include?(track_type)
      
      @name          = name
      @block         = block
      @track_options = track_options
      @type          = track_type
    end
    
    def exec!(object, options)
      if object.method(name.to_sym).arity > 1
        object.public_send(name.to_sym, options, **options)
      else
        object.public_send(name.to_sym, options)
      end
      
      @block.(options) if @block
    end
  end
end