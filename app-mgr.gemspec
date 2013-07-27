Gem::Specification.new do |s|
  s.name = 'app-mgr'
  s.version = '0.2.6'
  s.summary = 'app-mgr'
    s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb'] 
  s.signing_key = '../privatekeys/app-mgr.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/app-mgr'
end
