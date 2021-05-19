# Yabeda::Rack::Attack

Built-in metrics for rack-attack monitoring out of the box! Part of the [yabeda](https://github.com/yabeda-rb/yabeda) suite.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yabeda-rack-attack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yabeda-rack-attack

## Metrics

Local per-process metrics

# `rack_attack_throttled_requests_total` - counter of throttled requests (segmented by rack-attack name and descriminator)
# `rack_attack_tracked_requests_total` - counter of tracked requests (segmented by rack-attack name)
# `rack_attack_safelisted_requests_total` - counter of safelisted requests (segmented by name)
# `rack_attack_blocklisted_requests_total` - counter of blocklisted requests (segmented by name)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yabeda-rack-attack.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
