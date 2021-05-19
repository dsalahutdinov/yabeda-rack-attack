# frozen_string_literal: true

require 'yabeda/rack/attack/version'
require 'yabeda'
require 'rack/attack'
require 'yabeda/rack/attack/notifier'

module Yabeda
  module Rack
    module Attack
      ::Yabeda.configure do
        notifier = ::Yabeda::Rack::Attack::Notifier.new
        if defined?(ActiveSupport::Notifications)
          ActiveSupport::Notifications.subscribe(/rack_attack/) do |event_name, _start, _finish, _request_id, payload|
            request = payload[:request]
            notifier.instrument(event_name, request: request)
          end
        else
          ::Rack::Attack.notifier = notifier
        end

        group :rack_attack

        counter :throttled_requests_total, tags: %i[name discriminator],
                                           comment: 'Number of throttled requests my name/descriminator'
        counter :tracked_requests_total, tags: %i[name],
                                         comment: 'Number of tracked requests by name'
        counter :safelisted_requests_total, tags: %i[name],
                                            comment: 'Number of safelisted requests by name'
        counter :blocklisted_requests_total, tags: %i[name],
                                             comment: 'Number of blocklisted requests by name'
      end
      # Your code goes here...
    end
  end
end
