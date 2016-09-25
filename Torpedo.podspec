Pod::Spec.new do |s|
  s.name = 'Torpedo'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Swift on Crack'
  s.homepage = 'https://github.com/Onavoy/Torpedo'
  s.authors = { 'Hisham Alabri' => 'hisham@alabri.co' }
  s.source = { :git => 'https://github.com/Onavoy/Torpedo.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  #s.osx.deployment_target = '10.11'
  #s.tvos.deployment_target = '9.0'
  #s.watchos.deployment_target = '2.0'

  s.source_files = 'Torpedo/Classes/**/*.swift'
end