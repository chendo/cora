require "cora/version"
require "cora/plugin"
require "cora/location"

class Cora

  attr_reader :location

  def plugins
    @plugins ||= []
  end

  def process(text)
    log "Processing '#{text}'"

    if @callback
      log "Active callback found, resuming"

      # We must set the active callback to nil first, otherwise
      # multiple callbacks within one listen block won't work
      callback = @callback
      @callback = nil
      callback.call(text)
      return true
    end

    plugins.each do |plugin|
      log "Processing plugin #{plugin}"
      return true if plugin.process(text)
    end

    log "No matches for '#{text}'"
    no_matches
  end

  def respond(text, options = {})
  end

  def no_matches
  end

  def set_priority_plugin(plugin)
    plugins.delete(plugin)
    plugins.unshift(plugin)
  end

  def set_callback(&block)
    @callback = block
  end

  def set_active_fiber(fiber)
    @fiber = fiber
  end

  def set_location(latitude, longitude, extra = {})
    @location = Location.new(latitude, longitude, extra)
  end

  def log(text)
    $stderr.puts(text) if defined?(LOG)
  end
end
