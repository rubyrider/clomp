module ServiceObject
  class Track
    include ServiceObject::CommonStates
    
    attr_reader :name, :block, :track_options, :state, :error
    
    VALID_TRACK_TYPES = %I(track failed_track finally catch)
    
    def initialize(name: (raise Errors::NoTrackProvided), track_options: {}, track_type: VALID_TRACK_TYPES.first, &block)
      raise UnknownTrackType, 'Please provide a valid track type' unless VALID_TRACK_TYPES.include?(track_type)
      
      @name          = name
      @block         = block
      @track_options = track_options
      @type          = track_type
      @state         = 'pending'
      @error         = nil
    end
    
    # Track#exec! executes the steps defined in the operation class
    def exec!(object, options)
      mark_as_failure! # going to execute! set to failure initially
      
      if object.method(name.to_sym).arity > 1
        mark_as_success! if object.public_send(name.to_sym, options, **options) != false
      else
        mark_as_success! if object.public_send(name.to_sym, options) != false
      end
      
      @block.(options) if success? && @block
      
      self
    
    rescue => e
      @error = e.message
      
      self
    end
  end
end