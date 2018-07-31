Gem::Specification.new do |s|
  s.name = 'app-mgr'
  s.version = '0.3.1'
  s.summary = 'Runs 1 or more headless apps from a kind of XML ' + 
      'file for use in a back-end server'
    s.authors = ['James Robertson']
  s.files = Dir['lib/app-mgr.rb'] 
  s.signing_key = '../privatekeys/app-mgr.pem'
  s.add_runtime_dependency('rscript', '~> 0.5', '>=0.5.2')
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/app-mgr'
  s.required_ruby_version = '>= 2.1.2'
end
