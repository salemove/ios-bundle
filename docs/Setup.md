## Setup

To configure the SalemoveSDK, follow the steps:

1. [Generating an universal push certificate](#certificate-generation)
2. [Enabling push capabilities](#push-notifications)
3. [Configuring the project](#project-configuration)
4. [Configuring the sdk](#sdk-configuration)

### Push Notifications

In order for the project to receive chat messages and other events, [push capabilities][0] should be enabled for the target. SaleMove will use your certificate when sending messages via the Apple Push Notification Service to the SaleMove client in your app.

### Certificate generation

Be sure to generate the **universal production** certificate.

#### Fastlane

The easiest way to generate all the required files is to use [fastlane][1] built in tool called [pem][2].

#### Submitting

After the push certificate and the keys are generated, please submit *pem*, *p12* and *pkey* files to support@salemove.com.

### Project Configuration

The SalemoveSDK push service relies on [environment variables][3] so please make sure to add the `DEBUG` `1` to the run configuration. This will differentiate the gateway used to submit the messages.

The SalemoveSDK uses the audio/video capabilities of the device. As such, the hosting app needs [NSCameraUsageDescription][4] and [NSMicrophoneUsageDescription][5] added to the plist file.

The SalemoveSDK is not using Bitcode so this should be disabled for the project.

### SDK Configuration

he SalemoveSDK accepts four configuration options:

- In order to configure the developer APP token used by the SDK:
```swift
func configure(appToken: String)
```

- In order to configure the developer API token used by the SDK:
```swift
func configure(apiToken: String)
```

- In order to configure the environment used by the SDK:
```swift
func configure(environment: String)
```

- In order to configure the site ID used by the SDK:
```swift
func configure(site: String)
```

## What's next?

Check out the [integration guide][6].

## Author

SaleMove TechMovers, techmovers@salemove.com

## License

SalemoveSDK is available under the MIT license. See the LICENSE file for more info.

[0]: https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AddingCapabilities/AddingCapabilities.html 
[1]: https://docs.fastlane.tools
[2]: https://docs.fastlane.tools/actions/pem/
[3]: https://medium.com/@derrickho_28266/xcode-custom-environment-variables-681b5b8674ec
[4]: https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW24
[5]: https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW25
[6]: ./2017-11-28-Enhancing+Your+iOS+Application+With+Salmove+SDK.md

