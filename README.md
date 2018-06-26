# SaleMove iOS SDK

The complete guide to get started with the SaleMove iOS SDK.

## Prerequisites

Make sure that you have received a **developer API token** and **site ID** from your success manager at SaleMove.

### Requirements
- Xcode 9.1+
- iOS 10.0+
- Swift 3.2+

## Component Libraries

In order to make the library work correctly, it uses third party dependencies listed below:

- [SwiftyBeaver][6] - An advanced logging system
- [ReactiveCocoa][7] - Reactive support all over the SDK
- [Moya/ReactiveSwift][8] - An advanced networking layer built on top of Alamofire
- [Moya-ObjectMapper/ReactiveSwift][9] - An advanced mapping system


## Documentation
Can be found at our [here][5].

## Installation

### CocoaPods

[CocoaPods][0] is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build SalemoveSDK.

To incorporate SalemoveSDK into your Xcode project using CocoaPods specify it in your `Podfile`:

```ruby
source 'git@github.com:salemove/ios-cocoapods-repo.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SalemoveSDK'
end
```

Then, run the following command:

```bash
$ pod install
```

## Setup

To configure the SalemoveSDK, follow the steps:

1. [Generating a universal push certificate](#certificate-generation)
2. [Enabling the push capabilities](#push-notifications)
3. [Configuring the project](#project-configuration)
4. [Configuring the sdk](#sdk-configuration)

### Certificate generation

Be sure to generate the **universal production** certificate.

#### Fastlane

The easies way to generate all the required files is to use [fastlane][1] built in tool called [pem][2].

#### Submitting

After the push certificate and the keys are generated, please submit *pem*, *p12* and *pkey* files to support@salemove.com.

### Push Notifications

In order for the project to receive chat messages and other events, [push capabilities][3] should be enabled for the target.

### Project Configuration

The SalemoveSDK push service relies on [environment variables][4] so please make sure to add the `DEBUG` `1` to the run configuration. This will differentiate the gateway used to submit the messages.

### SDK Configuration

The SalemoveSDK currently accepts two configuration options:

- The site ID and environment are available by accessing:
```swift
Salemove.sharedInstance.configurationFile
```

- In order to configure the environment used by the SDK:
```swift
func configure(environment: String)
```

- In order to configure the site ID used by the SDK:
```swift
func configure(site: String)
```

## Author

SaleMove TechMovers, techmovers@salemove.com

## License

SalemoveSDK is available under the MIT license. See the LICENSE file for more info.


## What's next?

Check out the [integration guide][10].


[0]: http://cocoapods.org
[1]: https://docs.fastlane.tools
[2]: https://docs.fastlane.tools/actions/pem/
[3]: https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AddingCapabilities/AddingCapabilities.html
[4]: https://medium.com/@derrickho_28266/xcode-custom-environment-variables-681b5b8674ec
[5]: http://ios-sdk-docs.salemove.com.s3-website-us-east-1.amazonaws.com/index.html
[6]: https://github.com/SwiftyBeaver/SwiftyBeaver
[7]: https://github.com/ReactiveCocoa/ReactiveCocoa
[8]: https://github.com/Moya/Moya
[9]: https://github.com/ivanbruel/Moya-ObjectMapper
[10]: https://github.com/salemove/ios-bundle/blob/master/2017-11-28-Enhancing%2BYour%2BiOS%2BApplication%2BWith%2BSalmove%2BSDK.md
