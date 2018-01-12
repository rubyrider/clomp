module Clomp
  class Callable
    class << self
      def [](track, options, _self)
        if track.track_from
          #FIXME: stop executing! we will call it from our context
          track.track_from.new(track_builders: [track], options: options, exec: false)
        else
          _self
        end
      end
    end
  end
end