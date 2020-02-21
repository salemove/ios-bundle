# Quickstart

The complete guide to get started with the SaleMove iOS SDK. 

## Prerequisites

Make sure that you have received a **developer APP token**, **API token** and **site ID** from your success manager at Glia.

### Requirements
The reference table below shows the compatible SDK and environment versions that were tested and used for building the target project dependencies.

| SDK | 0.17.0  | 0.18.0 |   |
|---|---|---|---|
| *target iOS*   | 10.0+  | 10.0+  |   |
| *XCode*   | 11.2.1  | 11.2.1  | 11.3.1  |
| *Swift*   | 5.1.2 | 5.1.2  | 5.1.3  |
| *Obj-C*   | Supported | Supported  | Supported  |
| *Cocoapods*  | 1.8.4  | 1.8.4  | 1.8.4 |
| *Carthage*  | 0.34.0  | 0.34.0  |  0.34.0 |

Any higher versions, as long as newer versions are enough backward compatible, should work as well.

Please note that if you already have prebuilt frameworks that are built with older Swift versions then these frameworks should work with never environments as well. For example SDK 0.16.0 and its dependencies built with old XCode 10.2.1 should work when used in the newer XCode 11.3.1 project. 
However, if you are going to rebuild the older SDK (for example v0.16.0) on the newer environment, then there may be a problem with Swift compiler compatibility. So to build dependencies on the newer environment you need to find a compatible version of SDK.

## Installation

### Prepare git-lfs

Some of the dependencies are hosted using [git-lfs][3] so before using Cocoapods or Carthage make sure to have *git-lfs* installed and configured for your repository. It might take some time for all dependencies to load for the first time.

You can install it with the following command:

```bash
$ brew install git-lfs
```

A common mistake here is to install *git-lfs* after `git clone` or `git fetch`. So to get a clean environment, please install first *git-lfs* and then clone and pull your repositories that need *git-lfs*.

If *git-lfs* is not installed correctly then git fails to pull dependencies (WebRTC) that need *git-lfs*.

### CocoaPods

[CocoaPods][0] is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> Please see the environment requirements version reference table for compatible cocoapods version.

To incorporate SalemoveSDK into your Xcode project using CocoaPods specify it in your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SalemoveSDK', :git => 'https://github.com/salemove/ios-bundle', :tag => '<SDK Version>'
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
github "Salemove/ios-bundle", "0.18.0"
```

Run `carthage update --platform iOS` to build the framework.
This builds the framework and all its dependencies.

NOTE: There may be situations where you need to force building all dependency frameworks instead of using the prebuilt frameworks. In that case Run `carthage update --platform iOS --use-no-binaries` which builds all dependencies using your local Swift compiler.
At this point you need to be sure that your local Swift compiler is compatible with our SDK version - please see the requirements reference on top of the page. For example, you can not build SDK 0.16.0 with the newer XCode 11.1.3 environment, because you need updated dependencies that are compatible with the environment.

After building all dependencies, embed and link all frameworks into the XCode project. Also, Carthage never changes your existing project and thus the ways to embed and link may be slightly different depending on the XCode version and technique used.

NOTE: Carthage may pull versions of dependencies that maybe not compatible with certain systems. Please see the Known Issues section.

Check out the [carthage example][1].

[0]: http://cocoapods.org
[1]: https://github.com/salemove/ios-carthage-integration
[3]: https://git-lfs.github.com