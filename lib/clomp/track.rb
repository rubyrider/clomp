module Clomp
  class Track
    include Clomp::CommonStates
    
    attr_reader :name, :block, :track_options, :state, :error, :track_from, :left, :right
    attr_accessor :executed
    
    VALID_TRACK_TYPES = %I(track failed_track finally catch)
    
    def initialize(name: (raise Errors::NoTrackProvided), track_options: {}, right: true, track_from: nil, &block)
      @name          = name
      @track_from    = track_from
      @block         = block
      @track_options = track_options
      @state         = 'pending'
      @error         = nil
      @right         = true
      @executed      = false
    end
    
    def executed?
      @executed == true
    end
    
    def type
      @right ? :right_track : :left_track
    end
    
    alias_method :track?, :type
    
    def left_track?
      !right_track?
    end
    
    def right_track?
      @right
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
      
      pp @error
      
      mark_as_failure!
      
      self
    end
  end
end