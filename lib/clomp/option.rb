module Clomp
  class Option < ::Hash
    alias_method :_get, :[] # preserve the original #[] method
    protected :_get # make it protected
  
    def []=(key, value)
      super(key.to_sym, value)
    end
  
    def [](key)
      super(key.to_sym)
    end
  
    def set(key, value)
      self[key] = value
    end
  
    def method_missing(name, *args)
      name_string = name.to_s
      if name_string.chomp!('=')
        self[name_string] = args.first
      else
        bangs = name_string.chomp!('!')
      
        if bangs
          fetch(name_string.to_sym).presence || raise(KeyError.new("#{name_string} is blank."))
        else
          self[name_string]
        end
      end
    end
  
    def respond_to_missing?(name, include_private)
      true
    end
  end
end
