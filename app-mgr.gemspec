Gem::Specification.new do |s|
  s.name = 'app-mgr'
  s.version = '0.4.0'
  s.summary = 'Runs 1 or more headless apps from a kind of XML ' + 
      'file for use in a back-end server'
    s.authors = ['James Robertson']
  s.files = Dir['lib/app-mgr.rb'] 
  s.signing_key = '../privatekeys/app-mgr.pem'
  s.add_runtime_dependency('rscript', '~> 0.9', '>=0.9.0')
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/app-mgr'
  s.required_ruby_version = '>= 2.1.2'
end
