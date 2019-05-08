# Setup

The complete guide to configure the SaleMove iOS SDK.

See [explanation video][7]

## Steps

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

After the push certificate and the keys are generated, please submit *pem*, *p12* and *pkey* files to mobile@salemove.com.

### Project Configuration

The SalemoveSDK push service relies on [environment variables][3] so please make sure to add the `DEBUG` `1` to the run configuration. This will differentiate the gateway used to submit the messages.

The SalemoveSDK uses the audio/video capabilities of the device. As such, the hosting app needs [NSCameraUsageDescription][4] and [NSMicrophoneUsageDescription][5] added to the plist file.

The SalemoveSDK is not using Bitcode so this should be disabled for the project.

### SDK Configuration

The SalemoveSDK accepts four configuration options:

- APP Token is used for authentication while interacting with our REST API
```swift
func configure(appToken: String)
```

- API Token is used for Operator actions, for example quering for available Operators
```swift
func configure(apiToken: String)
```

- Environment URL can be either for Europe (https://api.salemove.eu) or USA (https://api.salemove.com)
```swift
func configure(environment: String)
```

- SiteID is used to help associate Visitors with your business and your application
```swift
func configure(site: String)
```

## What's next?

Check out the [integration guide][6].

[0]: https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AddingCapabilities/AddingCapabilities.html 
[1]: https://docs.fastlane.tools
[2]: https://docs.fastlane.tools/actions/pem/
[3]: https://medium.com/@derrickho_28266/xcode-custom-environment-variables-681b5b8674ec
[4]: https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW24
[5]: https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW25
[6]: ./Integration.md
[7]: https://drive.google.com/open?id=13OppFV2wN3OvM8Iod--MC1f34oww30mG

