Pod::Spec.new do |s|
  s.name             = 'SalemoveSDK'
  s.version          = '0.35.15'
  s.summary          = 'The Glia Core SDK'
  s.description      = 'The Glia Core SDK brings the in-person customer experience to iOS devices.'
  s.homepage         = 'https://www.glia.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Salemove' => 'support@salemove.com' }
  s.source           = { :git => 'https://github.com/salemove/ios-bundle.git', :tag => s.version.to_s }

  s.module_name = 'SalemoveSDK'
  s.ios.deployment_target = '12.0'
  s.ios.vendored_frameworks = 'SalemoveSDK.xcframework'
  s.swift_version = '5.3'

  s.dependency 'GliaCoreDependency', '1.2'
  s.dependency 'WebRTC-lib', '96.0.0'
  s.dependency 'TwilioVoice', '6.3.1'
end
