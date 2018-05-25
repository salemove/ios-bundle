#
# Be sure to run `pod lib lint SalemoveSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SalemoveSDK'
  s.version          = '0.7.7'
  s.summary          = 'A short description of SalemoveSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/salemove/ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Salemove' => 'support@salemove.com' }
  s.source           = { :git => 'git@github.com:salemove/ios-bundle.git', :tag => s.version.to_s }

  s.module_name = 'SalemoveSDK'
  s.ios.deployment_target = '10.0'
  s.ios.vendored_frameworks = 'SalemoveSDK.framework'

  s.pod_target_xcconfig = {
  'SWIFT_VERSION' => '4.1',
  }

  s.swift_version = '3.3'

  s.dependency 'SwiftyBeaver', '1.4.2'
  s.dependency 'ReactiveCocoa', '7.2.0'
  s.dependency 'Locksmith', '4.0.0'
  s.dependency 'Moya/ReactiveSwift', '11.0.2'
  s.dependency 'ObjectMapper', '3.1.0'
  s.dependency 'SwiftWebSocket', '2.6.5'
  s.dependency 'WebRTC', '63.11.20455'
  s.dependency 'Socket.IO-Client-Swift', '9.0.1'

end
