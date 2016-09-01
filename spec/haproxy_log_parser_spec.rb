require 'haproxy_log_parser'

RSpec.describe HAProxyLogParser do
  # TODO Use something better instead of LINES[0], LINES[1], ...
  LINES = IO.readlines(File.join(File.dirname(__FILE__), 'sample.log'))

  describe '.parse' do
    it 'parses LINE[0] correctly' do
      entry = HAProxyLogParser.parse(LINES[0])
      expect(entry.client_ip).to eq('10.0.8.2')
      expect(entry.client_port).to eq(34028)
      expect(entry.accept_date).to eq(Time.local(2011, 8, 9, 20, 30, 46, 429))
      expect(entry.frontend_name).to eq('proxy-out')
      expect(entry).to be_ssl
      expect(entry.backend_name).to eq('proxy-out')
      expect(entry.server_name).to eq('cache1')
      expect(entry.tq).to eq(1)
      expect(entry.tw).to eq(0)
      expect(entry.tc).to eq(2)
      expect(entry.tr).to eq(126)
      expect(entry.tt).to eq(128)
      expect(entry.status_code).to eq(301)
      expect(entry.bytes_read).to eq(223)
      expect(entry.captured_request_cookie).to eq({})
      expect(entry.captured_response_cookie).to eq({})
      expect(entry.termination_state).to eq('LR--')
      expect(entry.actconn).to eq(617)
      expect(entry.feconn).to eq(523)
      expect(entry.beconn).to eq(336)
      expect(entry.srv_conn).to eq(168)
      expect(entry.retries).to eq(0)
      expect(entry.srv_queue).to eq(0)
      expect(entry.backend_queue).to eq(0)
      expect(entry.captured_request_headers).to eq(['www.sytadin.equipement.gouv.fr', '', 'http://trafic.1wt.eu/'])
      expect(entry.captured_response_headers).to eq(['Apache', '230', '', '', 'http://www.sytadin.'])
      expect(entry.http_request).to eq('GET / HTTP/1.1')
    end

    it 'parses LINES[1] correctly' do
      entry = HAProxyLogParser.parse(LINES[1])
      expect(entry.client_ip).to eq('192.168.1.215')
      expect(entry.client_port).to eq(50679)
      expect(entry.accept_date).to eq(Time.local(2012, 5, 21, 1, 35, 46, 146))
      expect(entry.frontend_name).to eq('webapp')
      expect(entry).to_not be_ssl
      expect(entry.backend_name).to eq('webapp_backend')
      expect(entry.server_name).to eq('web09')
      expect(entry.tq).to eq(27)
      expect(entry.tw).to eq(0)
      expect(entry.tc).to eq(1)
      expect(entry.tr).to eq(0)
      expect(entry.tt).to eq(217)
      expect(entry.status_code).to eq(200)
      expect(entry.bytes_read).to eq(1367)
      expect(entry.captured_request_cookie).to eq({'session' => 'abc'})
      expect(entry.captured_response_cookie).to eq({'session' => 'xyz'})
      expect(entry.termination_state).to eq('----')
      expect(entry.actconn).to eq(600)
      expect(entry.feconn).to eq(529)
      expect(entry.beconn).to eq(336)
      expect(entry.srv_conn).to eq(158)
      expect(entry.retries).to eq(0)
      expect(entry.srv_queue).to eq(0)
      expect(entry.backend_queue).to eq(0)
      expect(entry.captured_request_headers).to eq(['|| {5F41}', 'http://google.com/', ''])
      expect(entry.captured_response_headers).to eq([])
      expect(entry.http_request).to eq('GET /images/image.gif HTTP/1.1')
    end

    it 'returns nil if the line is invalid' do
      expect(HAProxyLogParser.parse('asdf jkl;')).to be_nil
    end
  end
end
