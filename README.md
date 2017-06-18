# haproxy\_log\_parser

[![Build Status](https://travis-ci.org/tobyhs/haproxy_log_parser.svg?branch=master)](https://travis-ci.org/tobyhs/haproxy_log_parser)

haproxy\_log\_parser is a gem that parses logs in HAProxy's HTTP log format.
Use `HAProxyLogParser.parse` to parse a line; this will return an
`HAProxyLogParser::Entry` for normal lines and `HAProxyLogParser::ErrorEntry`
for connection error lines.

Example:

    require 'haproxy_log_parser'
    result = HAProxyLogParser.parse('Aug  9 20:30:46 localhost haproxy[2022]: 10.0.8.2:34028 [09/Aug/2011:20:30:46.429] proxy-out proxy-out/cache1 1/0/2/126/+128 301 +223 - - ---- 617/523/336/168/0 0/0 {www.sytadin.equipement.gouv.fr||http://trafic.1wt.eu/} {Apache|230|||true} "GET /index.html HTTP/1.1"')
    result.client_ip # => "10.0.8.2"
    result.captured_response_headers # => ["Apache", "230", "", "", "true"]
