require 'pp'

module Clomp
  class Executor
    class << self
      # _self = operation
      #
      def [](result = {}, options, _self:)
        result['tracks'].each_with_index do |track, i|
          next if _self.successful? && track.left_track?
          next if _self.failed? && track.right_track?
          break if i > 0 && result['tracks'][i -1].track_options[:fail_fast]
          break if i > 0 && result['tracks'][i -1].track_options[:pass_fast]
          
          _callable_object = Callable[track, options, _self]
          
          raise Errors::TrackNotDefined, "Please define the track in your operation/service: #{track.name} in #{_callable_object.class}" unless _callable_object.respond_to?(track.name)
          
          _track = track.exec!(_callable_object, options)
        end
        
        _self
      end
    end
  end
end