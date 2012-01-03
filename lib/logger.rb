class Logger
  class << self
    def info(message)
      create_log_entry(message, 'info')
    end

    def warning(message)
      create_log_entry(message, 'warn')
    end

    def error(message)
      create_log_entry(message, 'error')
    end

    private
    def create_log_entry(message, level='info')
      p "[#{level}] #{message}"
    end
  end
end
