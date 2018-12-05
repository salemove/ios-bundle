# Frequently Asked Questions

This is a list of questions we frequently get and problems that are often encountered. 

* [Example app not compiling](#example-app-not-compiling)
* [Why do we include a custom socket.io library](#why-do-we-include-a-custom-socket-library)
* [Why do we include 3rd party dependencies when using Carthage?](#why-do-we-include-3rd-party-dependencies-when-using-carthage)

## Example app not compiling

There is an Example app where the SDK is integrated using cocoapods. After checking out
the repository please remember to do 'pod install' to get all the dependencies. After that open the 
Example.xcworkspace and run the app.

## Why do we include a custom socket library?

The socket.io-client-swift we use no longer support socket 1.0 [so you need to include the 
pod by specifying repository and branch.](https://github.com/socketio/socket.io-client-swift/pull/1125)

The problem is that [Podspec does not have a way to specify branch or tag, only the Podfile can do this.](https://github.com/CocoaPods/CocoaPods/issues/2937) This is [intended behaviour by the Cocoapods creators](https://github.com/CocoaPods/CocoaPods/issues/3276) and this is not going to change in the distant future.

We do plan to migrate to new socket library later on and this issue should get resolved.

## Why do we include 3rd party dependencies when using Carthage?

Our client library is dynamically linking the libraries during the runtime but in order to provide the correct versions, we need to [download them and add to an application.](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) You are not obligated to get the dependencies using Carthage.

We are working on experimental static library that can also [speed up the launch times.](https://github.com/Carthage/Carthage#build-static-frameworks-to-speed-up-your-apps-launch-times)


