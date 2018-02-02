require 'pp'

module Clomp
  class Executor
    class << self
      # _self = operation
      #
      def [](result = {}, options, _self:)
        result['tracks'].each do |track|
          next if _self.successful? && track.left_track?
          next if _self.failed? && track.right_track?
          
          _callable_object = Callable[track, options, _self]
          
          raise Errors::TrackNotDefined, "Please define the track in your operation/service: #{track.name} in #{_callable_object.class}" unless _callable_object.respond_to?(track.name)
          
          _track = track.exec!(_callable_object, options)
          
          _track.executed = true
          
          # Considering pass first on success state
          break if _track.success? && (_track.track_options[:pass_fast])
          
          # Consider both local or global configuration
          break if _track.failure? && (_track.track_options[:fail_fast])
        end
        
        _self
      end
    end
  end
end