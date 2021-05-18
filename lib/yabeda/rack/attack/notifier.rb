# frozen_string_literal: true

module Yabeda
  module Rack
    module Attack
      class Notifier
        def instrument(event_type, request:)
          # backwards compatibility issues
          # https://github.com/rack/rack-attack/blob/2257f008763b405f6a1515b460f80ed5d0f06c2c/lib/rack/attack.rb#L42-L43
          case event_type
          when 'throttle.rack_attack'
            track_throttled(request)
          when 'track.rack_attack'
            track_tracked(request)
          when 'safelist.rack_attack'
            track_safelisted(request)
          when 'blocklist.rack_attack'
            track_blacklisted(request)
          end
        end

        private

        def track_throttled(request)
          ::Yabeda.rack_attack.throttled_requests_total.increment(
            { name: name(request), discriminator: discriminator(request) }
          )
        end

        def track_tracked(request)
          ::Yabeda.rack_attack.tracked_requests_total.increment(
            { name: name(request) }
          )
        end

        def track_safelisted(request)
          ::Yabeda.rack_attack.safelisted_requests_total.increment(
            { name: name(request) }
          )
        end

        def track_blacklisted(request)
          ::Yabeda.rack_attack.blocklisted_requests_total.increment(
            { name: name(request) }
          )
        end

        def name(request)
          request.env['rack.attack.matched']
        end

        def discriminator(request)
          request.env['rack.attack.match_discriminator']
        end
      end
    end
  end
end
