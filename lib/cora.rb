require "cora/version"
require "cora/plugin"

class Cora
  attr_accessor :active_plugin

  def plugins
    @plugins ||= []
  end

  def process(text)
    log "Processing '#{text}'"

    if @callback
      log "Active callback found, resuming"
      @callback.call(text)
      @callback = nil
      return true
    end

    plugins.each do |plugin|
      log "Processing plugin #{plugin}"
      return if plugin.process(text)
    end

    log "No matches for '#{text}'"
    no_matches
  end

  def respond(text)
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

  def log(text)
    $stderr.puts(text) if defined?(LOG)
  end
end
