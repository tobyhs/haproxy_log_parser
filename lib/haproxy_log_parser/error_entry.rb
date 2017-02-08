module HAProxyLogParser
  # An instance of this class represents a connection error line of an HAProxy
  # log. See the "Logging > Log formats > Error log format" section in
  # HAProxy's configuration.txt for documentation of fields.
  class ErrorEntry
    # @return [String]
    attr_accessor :client_ip

    # @return [Integer]
    attr_accessor :client_port

    # @return [Time]
    attr_accessor :accept_date

    # @return [String]
    attr_accessor :frontend_name

    # @return [String]
    attr_accessor :bind_name

    # @return [String]
    attr_accessor :message
  end
end
