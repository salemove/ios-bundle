# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and `SalemoveSDK` adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

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
