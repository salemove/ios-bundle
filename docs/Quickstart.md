# Quickstart

The complete guide to get started with the SaleMove iOS SDK. 

See [explanation video][2]

## Prerequisites

Make sure that you have received a **developer APP token**, **API token** and **site ID** from your success manager at SaleMove.

### Requirements
- Xcode 10.2.1+
- iOS 10.0+
- Swift 5.0

## Installation

### Prepare git-lfs

Some of the dependencies are hosted using [git-lfs][3] so before using Cocoapods or Carthage make sure to have git-lfs installed and configured for your repository. It might take some time for all dependencies to load for the first time.

### CocoaPods

[CocoaPods][0] is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.5+ is required to build SalemoveSDK.

To incorporate SalemoveSDK into your Xcode project using CocoaPods specify it in your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SalemoveSDK', :git => 'https://github.com/salemove/ios-bundle'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
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

Run `carthage update` to build the framework and drag the built `SalemoveSDK.framework` into your Xcode project along with any other dependencies.

Check out the [carthage example][1].

[0]: http://cocoapods.org
[1]: https://github.com/salemove/ios-carthage-integration
[2]: https://drive.google.com/open?id=1-QcgKyyZZ5YDMH3pBlebTg5jCaKNGDvE
[3]: https://git-lfs.github.com
