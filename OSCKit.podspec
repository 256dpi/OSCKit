Pod::Spec.new do |s|
  s.name = 'OSCKit'
  s.version = '0.1.1'
  s.summary = 'OSC protocol implementation.'
  s.homepage = 'https://github.com/256dpi/OSCKit'
  s.license = 'MIT'
  s.author = { "Joël Gähwiler" => "joel.gaehwiler@gmail.com" }
  s.source = { git: 'https://github.com/256dpi/OSCKit.git', tag: s.version }

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.source_files = 'OSCKit/**/*.{h,m,mm,cpp}'
  s.public_header_files = 'OSCKit/*.h'

  s.dependency 'CocoaAsyncSocket', '~> 7.3'
end
