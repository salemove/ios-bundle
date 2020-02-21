# Frequently Asked Questions

This is a list of questions we frequently get and problems that are often encountered. 

* [Example app not compiling](#example-app-not-compiling)
* [Why do we include 3rd party dependencies when using Carthage?](#why-do-we-include-3rd-party-dependencies-when-using-carthage)
* [What to do if your App does not support latest Swift and Xcode?](#what-to-do-if-your-app-does-not-support-latest-swift-and-xcode)

## Example app not compiling

There is an Example app where the SDK is integrated using cocoapods. After checking out
the repository please remember to do 'pod install' to get all the dependencies. After that open the 
Example.xcworkspace and run the app.

## Error fetching dependencies using Cocoapods

If you get something like `git-lfs filter-process: git-lfs: command not found` then this means that something is wrong with the configuration of git. Please try to install the [git-lfs](https://git-lfs.github.com) and then run `git lfs install` and fetch the dependencies again.

## Why do we include 3rd party dependencies when using Carthage?

Our client library is dynamically linking the libraries during the runtime but in order to provide the correct versions, we need to [download them and add to an application.](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) You are not obligated to get the dependencies using Carthage.

We are working on an experimental static library that can also [speed up the launch times.](https://github.com/Carthage/Carthage#build-static-frameworks-to-speed-up-your-apps-launch-times)

## Issues with Carhage

There is a known issue that Carthage sometimes pulls a little bit different dependency library versions than for example Cocoapod does. These versions may be incompatible with older environments. While Cocoapods is often able to automatically handle it by configuring the target project then Carthage does not touch your project at all.

* Pulling SDK v0.16.0 pulls a too high version of Starscream library. It pulls v4.0.0 which is incompatible on XCode 10.2.1 / Swift 5.0.1 environment. So in that case after running Carthage update the Starscream library must be replaced manually with its older version.

## What to do if your App does not support the latest Swift and Xcode?

Please see the Requirements section, which states the compatible SDK and environment versions.