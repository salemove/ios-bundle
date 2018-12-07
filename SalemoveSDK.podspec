Pod::Spec.new do |s|
  s.name             = 'SalemoveSDK'
  s.version          = '0.7.25'
  s.summary          = 'The Salemove iOS library'
  s.description      = 'The Salemove iOS library brings the in-person customer experience to iOS devices.'
  s.homepage         = 'https://github.com/salemove/ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Salemove' => 'support@salemove.com' }
  s.source           = { :git => 'git@github.com:salemove/ios-bundle/SalemoveSDK.framework.zip', :branch => 'static-library' }

  s.module_name = 'SalemoveSDK'
  s.ios.deployment_target = '10.0'
  s.ios.vendored_frameworks = 'SalemoveSDK.framework'
  s.swift_version = '4.2'

end
