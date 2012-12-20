Gem::Specification.new do |s|
  s.name = 'haproxy_log_parser'
  s.version = IO.read('VERSION').chomp
  s.authors = ['Toby Hsieh']
  s.homepage = 'https://github.com/tobyhs/haproxy_log_parser'
  s.summary = 'Parser for HAProxy logs in the HTTP log format'
  s.description = s.summary

  s.add_dependency 'treetop'

  s.add_development_dependency 'rspec'

  s.files = Dir.glob('lib/**/*') + [
    'README.rdoc',
    'VERSION',
    'haproxy_log_parser.gemspec'
  ]
  s.test_files = Dir.glob('spec/**/*')
end
