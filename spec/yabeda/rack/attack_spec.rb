# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
RSpec.describe Yabeda::Rack::Attack do
  include Rack::Test::Methods

  it 'has a version number' do
    expect(Yabeda::Rack::Attack::VERSION).not_to be nil
  end

  let(:cache_store) { MemoryStore.new }

  before(:all) { Yabeda.configure! }

  before do
    Rack::Attack.cache.store = cache_store

    Rack::Attack.throttle('throttled 1 time per minute by ip', limit: 1, period: 60) do |req|
      req.ip if req.path == '/throttled/1time/per1minute/by_ip'
    end

    Rack::Attack.track('special_agent') do |req|
      req.user_agent
    end

    Rack::Attack.safelist('safelist_header') do |req|
      req.env['HTTP_RACK_ATTACK'] == 'safelist'
    end

    Rack::Attack.blocklist('blocklist_header') do |req|
      req.env['HTTP_RACK_ATTACK'] == 'blocklist'
    end
  end

  it 'tracks throttles' do
    get '/throttled/1time/per1minute/by_ip'
    expect(last_response.ok?).to be_truthy

    get '/throttled/1time/per1minute/by_ip'

    expect { get '/throttled/1time/per1minute/by_ip' }.to change {
      ::Yabeda.rack_attack.throttled_requests_total.values[
        { name: 'throttled 1 time per minute by ip', discriminator: '127.0.0.1' }
      ]
    }.by 1

    expect(last_response.ok?).to be_falsey
  end

  it 'tracks  tracks' do
    header 'User-Agent', 'SpecialAgent'
    expect { get '/check/user-agent' }.to change {
      ::Yabeda.rack_attack.tracked_requests_total.values[
        { name: 'special_agent', discriminator: 'SpecialAgent' }
      ]
    }.by(1)

    expect(last_response.ok?).to be_truthy
  end

  it 'tracks safelists' do
    header 'RACK_ATTACK', 'safelist'
    expect { get '/safelist' }.to change {
      ::Yabeda.rack_attack.safelisted_requests_total.values[
        { name: 'safelist_header' }
      ]
    }.by 1
  end

  it 'tracks blocklists' do
    header 'RACK_ATTACK', 'blocklist'
    expect { get '/blocklist' }.to change {
      ::Yabeda.rack_attack.blocklisted_requests_total.values[
        { name: 'blocklist_header' }
      ]
    }.by 1
  end

  private

  def app
    Rack::Builder.new.tap do |builder|
      builder.use ::Rack::Attack
      builder.run app_class.new
    end
  end

  def app_class
    Class.new do
      def call(_env)
        [200, {}, ['dummy app']]
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
