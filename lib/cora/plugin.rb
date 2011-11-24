class Cora::Plugin

  class << self

    def listen_for(regex, &block)
      default_listeners[regex] = block
    end

    def default_listeners
      @default_listeners ||= {}
    end

  end

  def default_listeners
    self.class.default_listeners
  end

  def say(text)
    log "Say: #{text}"
  end

  def ask(question)
    log "Ask: #{question}"
  end

end
