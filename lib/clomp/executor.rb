require 'pp'

module Clomp
  class Executor
    class << self
      # _self = operation
      #
      def [](result = {}, options, _self:)
        result['tracks'].each do |track|
          next unless track.track?
          
          _callable_object = Callable[track, options, _self]
          
          raise Errors::TrackNotDefined, "Please define the track in your operation/service: #{track.name} in #{_callable_object.class}" unless _callable_object.respond_to?(track.name)
          
          _track = track.exec!(_callable_object, options)
          
          _self.executed << _track
          
          # Considering pass first on success state
          break if _track.success? && ((options[:pass_fast]) || Configuration.setup.pass_fast)
          
          # Consider both local or global configuration
          break if _track.failure? && ((options[:fail_fast]) || Configuration.setup.fail_fast)
        end
        
        _self
      end
    end
  end
end