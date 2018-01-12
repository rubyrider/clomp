require 'pp'

module Clomp
  class Executor
    class << self
      def [](result = {}, options, _self: )
        result['tracks'].each do |track|
          next unless track.track?
          
          _callable_object = Callable[track, options, _self]

          raise Errors::TrackNotDefined, "Please define the track in your operation/service: #{track.name} in #{_callable_object.class}" unless _callable_object.respond_to?(track.name)

          _track = track.exec!(_callable_object, options)
    
          break if _track.failure?
        end
  
        _self
      end
    end
  end
end