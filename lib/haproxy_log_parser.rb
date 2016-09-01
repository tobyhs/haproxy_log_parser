require 'treetop'

require 'haproxy_log_parser/entry'
require 'haproxy_log_parser/line'

module HAProxyLogParser
  VERSION = IO.read(File.join(File.dirname(__FILE__), '..', 'VERSION')).chomp.freeze

  # Exception for failures when parsing lines
  class ParseError < ::StandardError; end

  class << self
    # Returns an Entry object resulting from the given HAProxy HTTP-format log
    # +line+.
    #
    # @param line [String] a line from an HAProxy log
    # @return [Entry]
    # @raise [ParseError] if the line was not parsed successfully
    def parse(line)
      parser = LineParser.new
      result = parser.parse(line)

      unless result
        raise ParseError, parser.failure_reason
      end

      entry = Entry.new
      [
        :client_ip, :frontend_name, :transport_mode,
        :backend_name, :server_name, :termination_state
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
        if result.send(field).respond_to?(:headers)
          headers = decode_captured_headers(
            result.send(field).headers.text_value
          )
        else
          headers = []
        end
        entry.send("#{field}=", headers)
      end

      entry.http_request = unescape(result.http_request.text_value)

      entry
    end

    # Returns the given string un-escaped. See the "Logging > Non-printable
    # characters" section in HAProxy documentation.
    #
    # @param string [String] string to unescape
    # @return [String] an unescaped string
    def unescape(string)
      string.gsub(/#[[:xdigit:]]{2}/) do |match|
        match[1..-1].to_i(16).chr
      end
    end

    # Converts the value of an accept_date field to a Time object.
    #
    # @param string [String] value of an accept_date field
    # @return [Time]
    def parse_accept_date(string)
      parts = string.split(/[\/:.]/)
      Time.local(*parts.values_at(2, 1, 0, 3..6))
    end

    # Converts a captured cookie string to a Hash.
    #
    # @param string [String] a captured cookie string
    # @return [Hash{String => String}]
    #   a one-entry Hash with the cookie name and value, or an empty Hash if no
    #   cookie was captured
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
    # @param string [String] a captured headers section
    # @return [Array<String>] array of captured header values
    def decode_captured_headers(string)
      string.split('|', -1).map! { |header| unescape(header) }
    end
  end
end
