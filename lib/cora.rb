require "cora/version"
require "cora/plugin"

class Cora
  attr_accessor :active_plugin

  def plugins
    @plugins ||= []
  end

  def process(text)
    log "Processing '#{text}'"


    plugins.each do |plugin|
      log "Processing plugin #{plugin}"
      plugin.listeners.each do |regex, entry|

        if text =~ regex
          log "Matches #{regex}"

          if entry[:within_state]
            log "Applicable states: #{entry[:within_state].join(', ')}"
            log "Current state: #{plugin.current_state}"

            if entry[:within_state].include?(plugin.current_state)
              log "Matches, executing block"
              plugin.instance_exec(&entry[:block])

              log "Bailing from process loop"
              return
            end
          end
        end

      end
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

  def log(text)
    $stderr.puts(text) if defined?(LOG)
  end
end
