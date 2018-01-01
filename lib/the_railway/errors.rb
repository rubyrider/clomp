module TheRailway
  module Errors
    NoTrackProvided = Class.new(ArgumentError)
    TrackNotDefined = Class.new(NotImplementedError)
  end
end