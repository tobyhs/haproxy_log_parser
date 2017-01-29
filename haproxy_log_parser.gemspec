Gem::Specification.new do |s|
  s.name = 'haproxy_log_parser'
  s.version = IO.read('VERSION').chomp
  s.authors = ['Toby Hsieh']
  s.homepage = 'https://github.com/tobyhs/haproxy_log_parser'
  s.summary = 'Parser for HAProxy logs in the HTTP log format'
  s.description = s.summary
  s.license = 'MIT'

  s.add_dependency 'treetop'

  s.add_development_dependency 'rspec', '~> 3.5.0'

  s.files = `git ls-files`.split($/)
  s.test_files = s.files.grep(%r{\Aspec/})
end
