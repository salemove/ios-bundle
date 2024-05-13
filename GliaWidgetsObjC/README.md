# Objective-C Wrapper for [Glia Widgets](https://github.com/salemove/ios-sdk-widgets)

Glia Widgets iOS SDK is developed using pure Swift and does not provide Objective-C compatible interfaces. This sample Xcode project shows the possibility to get full compatibility with Objective-C.

**NB! This project is not kept up to date with latest GliaWidgetsSDK releases. It only shows how to get Objective-C interfaces.**

## Project

Xcode project nests all Glia Widgets SDK frameworks by introducing `GliaWidgetsWrapper.swift` that maps Swift interfaces to Objective-C.

## Working Principle
The `@objc` and `@objcMembers` attributes in Swift make Swift API available in Objective-C and the Objective-C runtime.

## Using the Wrapper

To import and use the `ios-sdk-widgets-objc` framework you need to:
1. Update the nested frameworks to latest versions. See ["Updating Dependencies"](#updating-dependencies) for guidelines.
2. Build the Xcode project to get `framework` to the `Products` folder.


## Updating Dependencies

The Xcode project does not use auto-updated dependency manager. To update dependencies, you can update the dependency manager manually using links from [Package.swift](https://github.com/salemove/ios-sdk-widgets/blob/master/Package.swift) in Glia Widgets iOS SDK official repository or add Swift Package Manager usage into project.