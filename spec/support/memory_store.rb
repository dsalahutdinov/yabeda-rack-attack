# frozen_string_literal: true

class MemoryStore
  def initialize
    @data = {}
  end

  def read(key)
    @data[key]
  end

  def increment(key, value, _options = {})
    @data[key] = 0 if @data[key].nil?
    @data[key] += value
  end

  def write(key, amount, _options = {})
    @data[key] = amount
  end
end
