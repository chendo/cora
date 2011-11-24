class Cora::Plugin

  attr_accessor :manager
  attr_reader :current_state

  class << self

    def listen_for(regex, options = {}, &block)
      listeners[regex] = {
        block: block,
        within_state: ([options[:within_state]].flatten)
      }
    end

    def listeners
      @listeners ||= {}
    end

  end

  def process(text)
    listeners.each do |regex, entry|
      if text =~ regex
        log "Matches #{regex}"

        if entry[:within_state]
          log "Applicable states: #{entry[:within_state].join(', ')}"
          log "Current state: #{current_state}"

          if entry[:within_state].include?(current_state)
            log "Matches, executing block"
            instance_exec(&entry[:block])

            return true
          end
        end
      end

    end
    false
  end

  def listeners
    self.class.listeners
  end

  def say(text)
    log "Say: #{text}"
    manager.respond(text)
  end

  def set_state(state)
    @current_state = state
    manager.set_priority_plugin(self)
  end

  def log(*args)
    manager.log(*args)
  end

end
