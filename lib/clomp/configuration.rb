module Clomp
  class Configuration
    attr_accessor :fail_fast, :pass_fast, :optional, :custom_step_names
    
    # Constructor for Configuration file
    def initialize
      @pass_fast         = false
      @fail_fast         = false
      @optional          = false
      @custom_step_names = [:step, :set]
    end
    
    class << self
      # Self configuration
      def config
        @config ||= new
    
        yield(@config) if block_given?
    
        @config
      end
  
      alias_method :setup, :config
    end
  end
end
