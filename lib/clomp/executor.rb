require 'pp'
require 'securerandom'

module Clomp
  class Executor
    class << self
      # _self = operation
      #
      def [](result = {}, options, _self:)
        result['tracks'].each_with_index do |track, i|
          
          break if break?(result['tracks'].select {|track|  track.executed? }, i)
          
          next if _self.successful? && track.left_track?
          next if _self.failed? && track.right_track?
          
          _callable_object = Callable[track, options, _self]
          
          raise Errors::TrackNotDefined, "Please define the track in your operation/service: #{track.name} in #{_callable_object.class}" unless _callable_object.respond_to?(track.name)
          
          _track = track.exec!(_callable_object, options)
        end
        
        _self
      end
      
      def break?(tracks, index)
        track = index > 0 && tracks[index -1] || Track.new(name: SecureRandom.hex(5)).tap {|track| track.mark_as_success! && track.executed = true}
        
        return true if track.right_track? && track.failure? && track.track_options[:fail_fast]
        
        return true if track.left_track? && track.track_options[:fail_fast]
        
        !track.track_options[:pass_fast].nil?
      end
    end
  end
end