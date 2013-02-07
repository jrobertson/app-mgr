Gem::Specification.new do |s|
  s.name = 'app-mgr'
  s.version = '0.2.5'
  s.summary = 'app-mgr'
    s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb'] 
  s.signing_key = '../privatekeys/app-mgr.pem'
  s.cert_chain  = ['gem-public_cert.pem']
end
