module Clomp
  module Errors
    NoTrackProvided  = Class.new(ArgumentError)
    TrackNotDefined  = Class.new(NotImplementedError)
    UnknownTrackType = Class.new(ArgumentError)
  end
end