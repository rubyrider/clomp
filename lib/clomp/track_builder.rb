module Clomp
  class TrackBuilder < Array
    class << self
      def [](track_name:, track_options: {}, track_for: nil, track_type:, &block)
        Track.new(name: track_name, track_options: track_options, right: track_type, track_from: track_for, &block)
      end
    end
  end
end

# 9dd796f8b50c23addaf020473df0c0430c3f37f4a8383459106eb1d72401433e