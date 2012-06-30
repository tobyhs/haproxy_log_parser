require 'treetop'

require 'haproxy_log_parser/entry'

Treetop.load(File.expand_path('haproxy_log_parser/line.treetop', File.dirname(__FILE__)))

module HAProxyLogParser
  VERSION = IO.read(File.join(File.dirname(__FILE__), '..', 'VERSION')).chomp.freeze

  @parser = LineParser.new

  class << self
    # Returns an Entry object resulting from the given HAProxy HTTP-format log
    # +line+, or +nil+ if the +line+ appears to be invalid.
    #
    # @param [String] line a line from an HAProxy log
    # @return [Entry, nil]
    def parse(line)
      result = @parser.parse(line)
      return nil unless result

      entry = Entry.new
      [
        :client_ip, :frontend_name, :backend_name, :server_name,
        :termination_state
      ].each do |field|
        entry.send("#{field}=", result.send(field).text_value)
      end
      [
        :client_port, :tq, :tw, :tc, :tr, :tt, :status_code, :bytes_read,
        :actconn, :feconn, :beconn, :srv_conn, :retries, :srv_queue,
        :backend_queue
      ].each do |field|
        entry.send("#{field}=", result.send(field).text_value.to_i)
      end

      entry.accept_date = parse_accept_date(result.accept_date.text_value)
      [:captured_request_cookie, :captured_response_cookie].each do |field|
        cookie = decode_captured_cookie(result.send(field).text_value)
        entry.send("#{field}=", cookie)
      end
      [:captured_request_headers, :captured_response_headers].each do |field|
        headers = decode_captured_headers(result.send(field).text_value)
        entry.send("#{field}=", headers)
      end
      entry.http_request = unescape(result.http_request.text_value)

      entry
    end

    # Returns the given string un-escaped. See the "Logging > Non-printable
    # characters" section in HAProxy documentation.
    #
    # @param [String] string
    # @return [String]
    def unescape(string)
      string.gsub(/#[[:xdigit:]]{2}/) do |match|
        match[1..-1].to_i(16).chr
      end
    end

    # Converts the value of an accept_date field to a Time object.
    #
    # @param [String] string
    # @return [Time]
    def parse_accept_date(string)
      parts = string.split(/[\/:.]/)
      Time.local(*parts.values_at(2, 1, 0, 3..6))
    end

    # Converts a captured cookie string to a Hash.
    #
    # @param [String] string
    # @return [Hash{String => String}]
    def decode_captured_cookie(string)
      if string == '-'
        {}
      else
        key, value = string.split('=', 2)
        {unescape(key) => unescape(value)}
      end
    end

    # Converts a captured headers string to an Array.
    #
    # @param [String] string
    # @return [Array<String>]
    def decode_captured_headers(string)
      string.split('|', -1).map! { |header| unescape(header) }
    end
  end
end
