# Frequently Asked Questions

This is a list of questions we frequently get and problems that are often encountered. 

* [Example app not compiling](#example-app-not-compiling)
* [Why do we include 3rd party dependencies when using Carthage?](#why-do-we-include-3rd-party-dependencies-when-using-carthage)
* [What to do if your App does not support latest Swift and Xcode?](#what-to-do-if-your-app-does-not-support-latest-swift-and-xcode)

## Example app not compiling

There is an Example app where the SDK is integrated using cocoapods. After checking out
the repository please remember to do 'pod install' to get all the dependencies. After that open the 
Example.xcworkspace and run the app.

## Why do we include 3rd party dependencies when using Carthage?

Our client library is dynamically linking the libraries during the runtime but in order to provide the correct versions, we need to [download them and add to an application.](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) You are not obligated to get the dependencies using Carthage.

We are working on experimental static library that can also [speed up the launch times.](https://github.com/Carthage/Carthage#build-static-frameworks-to-speed-up-your-apps-launch-times)

## What to do if your App does not support latest Swift and Xcode?

Our client library minimum requirement is Xcode 10.0 and Swift 4.2 

One possible way of using the client library is [updating the Swift version to 4.2](https://useyourloaf.com/blog/upgrading-to-swift-4.2/)
