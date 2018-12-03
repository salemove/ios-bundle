# SaleMove iOS SDK

The complete guide to get started with the SaleMove iOS SDK.

## Prerequisites

Make sure that you have received a **developer APP token**, **API token** and **site ID** from your success manager at SaleMove.

### Requirements
- Xcode 10.0+
- iOS 10.0+
- Swift 4.2+

## Installation

### CocoaPods

[CocoaPods][0] is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.5+ is required to build SalemoveSDK.

To incorporate SalemoveSDK into your Xcode project using CocoaPods specify it in your `Podfile`:

```ruby
source 'git@github.com:salemove/ios-cocoapods-repo.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SalemoveSDK', :git => 'https://github.com/salemove/ios-bundle'
    pod 'Socket.IO-Client-Swift', :git => 'https://github.com/socketio/socket.io-client-swift', :branch => '1.0-swift4'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SalemoveSDK into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Salemove/ios-bundle"
```

Run `carthage update` to build the framework and drag the built `SalemoveSDK.framework` into your Xcode project.

SalemoveSDK uses 3rd party dependencies which need to be also added to the project:

```ogdl
github "SwiftyBeaver/SwiftyBeaver" == 1.4.2
github "matthewpalmer/Locksmith" == 4.0.0
github "Moya/Moya" == 11.0.2
github "Hearst-DD/ObjectMapper" == 3.3.0
github "davidstump/SwiftPhoenixClient" == 0.9.1
github "Anakros/WebRTC" == 63.11.20455
github "socketio/Socket.IO-Client-Swift" == 9.0.1
github "Exyte/Macaw" ~> 0.9.3
```

Check out the [carthage example][1].

## Author

SaleMove TechMovers, techmovers@salemove.com

## License

SalemoveSDK is available under the MIT license. See the LICENSE file for more info.

[0]: http://cocoapods.org
[1]: https://github.com/salemove/ios-carthage-integration
