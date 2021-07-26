# Change Log

## Unreleased

Unreleased: https://github.com/salemove/ios-sdk/compare/0.30.0...master

## [0.30.0] - 2021-07-26

### Added

- Added push notification support
- Added possibility to fetch visitor information
- Added possibility to start engagement with media
  
### Fixed

- Fixed media streaming on engagement transfer

[0.30.0]: https://github.com/salemove/ios-sdk/compare/0.29.6...0.30.0

## [0.29.6] - 2021-07-01
  
### Fixed

- Fixed `Avoiding duplicate symbols with static libraries/frameworks` issue (Swift Package Manager)

[0.29.6]: https://github.com/salemove/ios-sdk/compare/0.29.4...0.29.6

## [0.29.4] - 2021-06-17

### Fixed

- Fixed fetching file issue after engagement is ended.
- Fixed intermittent issues with video upgrades.

[0.29.4]: https://github.com/salemove/ios-sdk/compare/0.29.3...0.29.4

## [0.29.3] - 2021-05-19

### Fixed

- Improved stability of media upgrade requests.

[0.29.3]: https://github.com/salemove/ios-sdk/compare/0.29.2...0.29.3

## [0.29.2] - 2021-05-14

### Fixed

- Fixed media upgrades not being available in some corner cases.

[0.29.2]: https://github.com/salemove/ios-sdk/compare/0.29.1...0.29.2

## [0.29.1] - 2021-05-13

### Fixed

- Fixed video stream issues that appeared under certain network conditions.

[0.29.1]: https://github.com/salemove/ios-sdk/compare/0.29.0...0.29.1

## [0.29.0] - 2021-05-11

### Fixed

- Fixes SDK initialization deleting all keys in the keychain.
- Fixes issue with screen sharing not initializing properly.

[0.29.0]: https://github.com/salemove/ios-sdk/compare/0.28.0...0.29.0

## [0.28.0] - 2021-03-16

### Changed

- Added response card image URL support.

[0.28.0]: https://github.com/salemove/ios-sdk/compare/0.27.0...0.28.0

## [0.27.0] - 2021-02-23

### Changed

- Support for Swift Package Manager.
- Cocoapods now delivers an XCFramework instead of a Framework.

[0.27.0]: https://github.com/salemove/ios-sdk/compare/0.26.1...0.27.0

## [0.26.1] - 2021-01-19

### Changed

- Support for Xcode version 12.3.

[0.26.0]: https://github.com/salemove/ios-sdk/compare/0.26.0...0.26.1

## [0.26.0] - 2021-01-18

### Changed

- Improved management of queue tickets.
- Added support for sending and receiving files.
- Added support for sending and receiving single choice messages.
- Internal optimizations.

[0.26.0]: https://github.com/salemove/ios-sdk/compare/0.25.0...0.26.0

## [0.25.0] - 2020-10-29

### Changed

- Added support for selecting which push notification to enable
- Removed third party dependency: ObjectMapper
- Internal optimizations
- Fixed screen sharing option showing as available on some simulators

[0.25.0]: https://github.com/salemove/ios-sdk/compare/0.24.0...0.25.0

## [0.24.0] - 2020-09-17

### Fixed

- Added support for building on Simulators using XCode 12
- Attempting to send a message preview on an async chat type reports an error instead of silently failing

[0.24.0]: https://github.com/salemove/ios-bundle/compare/0.23.0...0.24.0

## [0.23.0] - 2020-09-10

### Changed

- Added support building with XCode 12 for iOS14
- Improved internal error logging

### Fixed

- Fixed handling push notifications when they are touched after app was force closed.

[0.23.0]: https://github.com/salemove/ios-bundle/compare/0.22.0...0.23.0


## [0.22.0] - 2020-08-18

### Changed

- Added support for requesting engaged operator information
- Internal optimizations

[0.22.0]: https://github.com/salemove/ios-bundle/compare/0.21.1...0.22.0


## [0.21.1] - 2020-07-10

### Changed

- Fixed the Log class access modifier 
- Fixed Keychain problem when using real devices

[0.21.1]: https://github.com/salemove/ios-bundle/compare/0.21.0...0.21.1

## [0.21.0] - 2020-06-16

### Changed

- Remove SwiftyBeaver from dependencies
- Remove Locksmith from dependencies
- Remove iOS 10 from supported platforms
- Add TwilioVoice to dependencies
- Add operator picture and media information
- Add support for operator phone and SIP audio
- Add more control over the log levels

[0.21.0]: https://github.com/salemove/ios-bundle/compare/0.20.0...0.21.0

## [0.20.0] - 2020-05-06

### Changed

- Upgrade SDK to Swift 5.2 and XCode 11.4

[0.20.0]: https://github.com/salemove/ios-bundle/compare/0.19.0...0.20.0

## [0.19.0] - 2020-03-10

### Changed

- Typing indicator improvements

### Fixed

- Fixes carthage issues with incompatible Starscream dependency

[0.19.0]: https://github.com/salemove/ios-bundle/compare/0.18.0...0.19.0

## [0.18.0] - 2020-01-07

### Changed

- Upgraded to Moya 14.0.0-beta.6 and ReactiveSwift 6.1.0

[0.18.0]: https://github.com/salemove/ios-bundle/compare/0.17.0...0.18.0

## [0.17.0] - 2019-12-12

### Changed

- Support for XCode 11.2 and Swift 5.1.2 (Cocoapods)

[0.17.0]: https://github.com/salemove/ios-bundle/compare/0.16.3...0.17.0


## [0.16.3] - 2019-11-26

### Fixed

- Incorect SDK version in logs

[0.16.3]: https://github.com/salemove/ios-bundle/compare/0.16.2...0.16.3

## [0.16.2] - 2019-11-18

### Fixed

- Operator typing status not being updated after transfer

[0.16.2]: https://github.com/salemove/ios-bundle/compare/0.16.0...0.16.2

## [0.16.0] - 2019-10-17

### Added

- Queue state
- Queue state subscriptions

### Fixed

- Old messages appearing after Engagement end

[0.16.0]: https://github.com/salemove/ios-bundle/compare/0.15.0...0.16.0

## [0.15.0] - 2019-07-25

### Changed

- Media establishing internals

### Added

- Media accept/decline completion block

## [0.14.4] - 2019-06-07

### Added

- Sending message preview

## [0.14.3] - 2019-05-30

### Changed

- Internal chat messages handling

## [0.14.2] - 2019-05-27

### Fixed

- Push services certificate

## [0.14.1] - 2019-05-08

### Changed

- Moya version to 13.0.1

## [0.14.0] - 2019-05-03

### Added

- Update information of the visitor

## [0.13.1] - 2019-04-25

### Added

- Swift 5.0 support

## [0.13.0] - 2019-04-23

### Added

- Xcode 10.2 support

## [0.12.0] - 2019-04-08

### Added

- Bitcode support

### Changed

- WebRTC library now includes bitcode

### Fixed

- Propogating SalemoveError when Engagement failed to start for some reason

## [0.11.0] - 2019-03-20

### Added

- onVisitorScreenSharingStateChange to MediaHandling

### Fixed

- Errors returned by the client library

## [0.10.0] - 2019-03-13

### Added

- onOperatorTypingStatusUpdate to MessageHandling

### Fixed

- ScreenSharing issue for OmniBrowse

## [0.9.1] - 2019-02-26

### Fixed

- Some methods calling UI changes not from the main thread

## [0.9.0] - 2019-02-26

### Added

- Visitor context configuration for the CoBrowsing content

### Fixed

- Screensharing multiple session problem

## [0.8.0] - 2019-02-22

### Fixed

- Some of the push notification issues

## [0.7.32] - 2019-02-04

### Added

- LocalScreen class to cancel an active screensharing

### Fixed

- Some issue with visitor_state context and multiple requests in a row

## [0.7.31] - 2019-01-30

### Added

- Video resize optins for the StreamView

## [0.7.30] - 2019-01-22

### Fixed

- Objc header generation

- Swift 4.2 lib lint issues

## [0.7.29] - 2019-01-11

### Added

- Visitor code request for OmniBrowse

## [0.7.28] - 2019-01-07

### Fixed

- Testflight submission with fastlane

## [0.7.27] - 2019-01-04

### Fixed

- General fixes of the engagement bugs

## [0.7.26] - 2018-12-18

### Added

- Audio control mute/unmute

### Removed

- OperatorHandling protocol

### Fixed

- General SDK fixes

## [0.7.25] - 2018-12-7

### Added

- Session handling

## [0.7.24] - 2018-12-7

### Fixed

- SDK configuration

- Video during Engagement

## [0.7.23] - 2018-11-30

### Added

- API token configuration

## [0.7.20] - 2018-11-27

### Fixed

- Screensharing lifecycle

- Engagement lifecycle

## [0.7.19] - 2018-11-15

### Changed

- Internal visitor state handling

- Overlay drawing

## [0.7.18] - 2018-11-09

### Changed

- Internal visitor state handling

- Overlay drawing

## [0.7.17] - 2018-10-31

### Changed

- Internal usage of the access tokens

- More reliable visitor state handling

## [0.7.16] - 2018-10-16

### Changed

- Internal usage of access tokens

## [0.7.15] - 2018-10-08

### Added

- Carthage support

- Swift 4.2 support

## [0.7.14] - 2018-09-12

### Changed

- Replace SwiftyWebSocket with SwiftPhoenixClient

## [0.7.13] - 2018-08-27

### Added

- Screen sharing possbbilities

## [0.7.12] - 2018-08-10

### Fixed

- Aspect ration of the video

- Operator offering two-way video

## [0.7.11] - 2018-07-23

### Fixed

- Crash when finishing an engagement

## [0.7.10] - 2018-07-18

### Added

- Two-way video support

### Changed

- Environment URL handling

## [0.7.9] - 2018-05-24

### Added

- Messages updates are delivered through `onMessagesUpdated` callback of the `MessageHandling` protocol

## [0.7.8] - 2018-05-24

### Added

- Ability to configure log levels of the library

## [0.7.7] - 2018-05-01

### Changed

- Support Swift 4.1 and 3.3 compatability mode for some dependencies

### Removed

- Moya-ObjectMapper dependency

### Added

- ObjectMapper dependency

## [0.7.6] - 2018-03-21

### Added

- Crashlytics integration to the demo app

### Changed

- Internals to support better client library distribution

### Removed

- Sensitive information removed from the project

## [0.7.5] - 2018-03-02

### Added

- One way video support to the client library
- onMediaStreamAdded handling requirement for the Interactable

## [0.7.4] - 2018-02-23

### Changed

- SiteID configuration now does not rely on hardcoded values

### Removed

- Configuration file from the client library

## [0.7.3] - 2018-02-21

### Added

- Two way audio support to the client library

### Changed

- Mediable protocol so the method now is called `requestMediaUpgrade` for requesting a communication

## [0.7.2] - 2018-02-07

### Added

- Ability to accept one way audio request from the Operator

## [0.7.1] - 2018-01-16

### Changed

- API now throws an error when providing incorrect configuration

### Fixed

- Fix messaging and queue selection for different site ID

## [0.7.0] - 2018-01-16

### Added

- Additional callback for push handling
- Ability to list all queues for configured site

## [0.6.0] - 2018-01-11

### Added

- Correct way of canceling and Engagement request
- Swift 4 support
- Sending Chat Message without an active Engagement

## [0.5.0] - 2018-01-4

### Changed

- Wrap chat message into Message object with ID and sender information

### Fixed

- Fix typos in documentation

## [0.4.0] - 2018-01-3

### Added

- Queueing for an Engagement
- SalemoveError for better understanding of the errors
- Scoping of the API, clearer objects
- Ability to configure the app token

## [0.3.0] - 2017-12-18

### Added
- Websockets for keeping the incoming callbacks and messaging more stable
- applicationDidBecomeActive manageable by SDK
- Additional server selection

## [0.2.1] - 2017-11-28

### Changed
- Rename in the SDK the way to queue for an engagement

### Removed
- Ability to specify the interactor directly in the SDK, now using a configurable protocol

## [0.2.0] - 2017-11-23

### Added
- Ability to configure the SDK from the API
- SDK to accept the Interactable object as part of the engagement handling
- Ability to generate the documentation using jazzy

### Changed
- SDK now is compiled as a library, so the source code is closed

### Removed
- echo example query for the push notifications
- UI code for the SDK

## [0.1.0] - 2017-11-16

### Added
- Initial version of the SDK
