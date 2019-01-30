Pod::Spec.new do |s|
  s.name             = 'SalemoveSDK'
  s.version          = '0.7.31'
  s.summary          = 'The Salemove iOS library'
  s.description      = 'The Salemove iOS library brings the in-person customer experience to iOS devices.'
  s.homepage         = 'https://github.com/salemove/ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Salemove' => 'support@salemove.com' }
  s.source           = { :git => 'git@github.com:salemove/ios-bundle.git', :tag => s.version.to_s }

  s.module_name = 'SalemoveSDK'
  s.ios.deployment_target = '10.0'
  s.ios.vendored_frameworks = 'SalemoveSDK.framework'
  s.swift_version = '4.2'

  s.dependency 'SwiftyBeaver', '1.6.1'
  s.dependency 'Locksmith', '4.0.0'
  s.dependency 'Moya', '12.0.1'
  s.dependency 'ReactiveSwift', '4.0.0'
  s.dependency 'ObjectMapper', '3.4.2'
  s.dependency 'SwiftPhoenixClient', '0.9.3'
  s.dependency 'WebRTC', '63.11.20455'
  s.dependency 'ios-socket-client', '9.0.2'
  s.dependency 'Macaw', '0.9.3'

end
