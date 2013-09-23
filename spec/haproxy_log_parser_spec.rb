require 'haproxy_log_parser'

describe HAProxyLogParser do
  # TODO Use something better instead of LINES[0], LINES[1], ...
  LINES = IO.readlines(File.join(File.dirname(__FILE__), 'sample.log'))

  describe '.parse' do
    it 'parses LINE[0] correctly' do
      entry = HAProxyLogParser.parse(LINES[0])
      entry.client_ip.should == '10.0.8.2'
      entry.client_port.should == 34028
      entry.accept_date.should == Time.local(2011, 8, 9, 20, 30, 46, 429)
      entry.frontend_name.should == 'proxy-out'
      expect(entry).to be_ssl
      entry.backend_name.should == 'proxy-out'
      entry.server_name.should == 'cache1'
      entry.tq.should == 1
      entry.tw.should == 0
      entry.tc.should == 2
      entry.tr.should == 126
      entry.tt.should == 128
      entry.status_code.should == 301
      entry.bytes_read.should == 223
      entry.captured_request_cookie.should == {}
      entry.captured_response_cookie.should == {}
      entry.termination_state.should == '----'
      entry.actconn.should == 617
      entry.feconn.should == 523
      entry.beconn.should == 336
      entry.srv_conn.should == 168
      entry.retries.should == 0
      entry.srv_queue.should == 0
      entry.backend_queue.should == 0
      entry.captured_request_headers.should == ['www.sytadin.equipement.gouv.fr', '', 'http://trafic.1wt.eu/']
      entry.captured_response_headers.should == ['Apache', '230', '', '', 'http://www.sytadin.']
      entry.http_request.should == 'GET http://www.sytadin.equipement.gouv.fr/ HTTP/1.1'
    end

    it 'parses LINES[1] correctly' do
      entry = HAProxyLogParser.parse(LINES[1])
      entry.client_ip.should == '192.168.1.215'
      entry.client_port.should == 50679
      entry.accept_date.should == Time.local(2012, 5, 21, 1, 35, 46, 146)
      entry.frontend_name.should == 'webapp'
      expect(entry).to_not be_ssl
      entry.backend_name.should == 'webapp_backend'
      entry.server_name.should == 'web09'
      entry.tq.should == 27
      entry.tw.should == 0
      entry.tc.should == 1
      entry.tr.should == 0
      entry.tt.should == 217
      entry.status_code.should == 200
      entry.bytes_read.should == 1367
      entry.captured_request_cookie.should == {'session' => 'abc'}
      entry.captured_response_cookie.should == {'session' => 'xyz'}
      entry.termination_state.should == '----'
      entry.actconn.should == 600
      entry.feconn.should == 529
      entry.beconn.should == 336
      entry.srv_conn.should == 158
      entry.retries.should == 0
      entry.srv_queue.should == 0
      entry.backend_queue.should == 0
      entry.captured_request_headers.should == ['|| {5F41}', 'http://google.com/', '']
      entry.captured_response_headers.should == ['1270925568', '', '']
      entry.http_request.should == 'GET /images/image.gif HTTP/1.1'
    end

    it 'returns nil if the line is invalid' do
      HAProxyLogParser.parse('asdf jkl;').should be_nil
    end
  end
end
