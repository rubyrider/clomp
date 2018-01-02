module TheRailway
  module CommonStates
    FAILURE = 'failure'
    SUCCESS = 'success'
    PENDING = 'pending'
    
    # Track#pending? not executed tracks!
    def pending?
      @state && @state == PENDING
    end
    
    # Track#success? successfully executed!
    def success?
      @state && @state == SUCCESS
    end
    
    # Track#failure? successfully failure!
    def failure?
      @state && @state == FAILURE
    end
    
    # Track#mark_as_success! flag the track as successful track
    # FIXME improve the flagship of track status! Should we use integer instead of string?
    def mark_as_success!
      @state && @state = SUCCESS
    end
    
    # Track#mark_as_failure! flag the track as unsuccessful track
    def mark_as_failure!
      @state && @state = FAILURE
    end
    
    # Any exception raise!
    def exception_raised?
      @error && @error.present?
    end
  end
end