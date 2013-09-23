module HAProxyLogParser
  # An instance of this class represents a line/entry of an HAProxy log in the
  # HTTP format. See the "Logging > Log formats > HTTP log format" section in
  # HAProxy's configuration.txt for documentation of fields/attributes.
  class Entry
    # @return [String]
    attr_accessor :client_ip

    # @return [Integer]
    attr_accessor :client_port

    # @return [Time]
    attr_accessor :accept_date

    # @return [String]
    attr_accessor :frontend_name

    # @return [String]
    #   '~' if SSL, '' otherwise (HAProxy 1.5 adds a '~' suffix to the frontend
    #   name if request went through SSL)
    attr_accessor :transport_mode

    # @return [String]
    attr_accessor :backend_name

    # @return [String]
    attr_accessor :server_name

    # @return [Integer]
    attr_accessor :tq

    # @return [Integer]
    attr_accessor :tw

    # @return [Integer]
    attr_accessor :tc

    # @return [Integer]
    attr_accessor :tr

    # @return [Integer]
    attr_accessor :tt

    # @return [Integer]
    attr_accessor :status_code

    # @return [Integer]
    attr_accessor :bytes_read

    # @return [Hash{String => String}]
    attr_accessor :captured_request_cookie

    # @return [Hash{String => String}]
    attr_accessor :captured_response_cookie

    # @return [String]
    attr_accessor :termination_state

    # @return [Integer]
    attr_accessor :actconn

    # @return [Integer]
    attr_accessor :feconn

    # @return [Integer]
    attr_accessor :beconn

    # @return [Integer]
    attr_accessor :srv_conn

    # @return [Integer]
    attr_accessor :retries

    # @return [Integer]
    attr_accessor :srv_queue

    # @return [Integer]
    attr_accessor :backend_queue

    # @return [Array<String>]
    attr_accessor :captured_request_headers

    # @return [Array<String>]
    attr_accessor :captured_response_headers

    # @return [String]
    attr_accessor :http_request

    # return [true, false] true if and only if request was SSL
    def ssl?
      @transport_mode == '~'
    end
  end
end
