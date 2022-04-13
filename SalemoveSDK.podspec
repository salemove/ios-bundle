Pod::Spec.new do |s|
  s.name             = 'SalemoveSDK'
  s.version          = '0.33.1'
  s.summary          = 'The Salemove iOS library'
  s.description      = 'The Salemove iOS library brings the in-person customer experience to iOS devices.'
  s.homepage         = 'https://github.com/salemove/ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Salemove' => 'support@salemove.com' }
  s.source           = { :git => 'https://github.com/salemove/ios-bundle.git', :tag => s.version.to_s }

  s.module_name = 'SalemoveSDK'
  s.ios.deployment_target = '12.0'
  s.ios.vendored_frameworks = 'SalemoveSDK.xcframework'
  s.swift_version = '5.3'

  s.dependency 'ReactiveSwift', '6.5.0-xcf'
  s.dependency 'SwiftPhoenixClient', '1.2.1-xcf'
  s.dependency 'SocketIO', '9.2.0-xcf'
  s.dependency 'Starscream', '3.1.1-xcf'
  s.dependency 'WebRTC-lib', '96.0.0'
  s.dependency 'TwilioVoice', '6.3.1'
end