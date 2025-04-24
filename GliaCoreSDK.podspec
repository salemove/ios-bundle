Pod::Spec.new do |s|
  s.name             = 'GliaCoreSDK'
  s.version          = '2.1.2'
  s.summary          = 'The Glia Core SDK'
  s.description      = 'The Glia Core SDK brings the in-person customer experience to iOS devices.'
  s.homepage         = 'https://www.glia.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Glia' => 'support@glia.com' }
  s.source           = { :git => 'https://github.com/salemove/ios-bundle.git', :tag => s.version.to_s }

  s.module_name = 'GliaCoreSDK'
  s.ios.deployment_target = '13.0'
  s.ios.vendored_frameworks = 'GliaCoreSDK.xcframework'
  s.swift_version = '5.3'

  s.dependency 'GliaCoreDependency', '2.3.0'
  s.dependency 'WebRTC-lib', '119.0.0'
  s.dependency 'TwilioVoice', '6.8.0'
end
