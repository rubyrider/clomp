module Clomp
  class Configuration
    attr_accessor :fail_fast, :pass_fast, :optional
    
    # Constructor for Configuration file
    def initialize
      @pass_fast = false
      @fail_fast = false
      @optional  = false
    end
  end
end
