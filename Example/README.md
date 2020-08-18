# Setup Instructions

## Configure credentials
Find the Configuration.plist file in project tree and replace the placeholders with your credentials

* BASE_URL
* APP_TOKEN
* API_TOKEN
* SITE_ID

The values can be asked from Glia.

[Documentation](https://developer.glia.com/api-usage-refs/ios-api)

# App Usage Instructions

* Ensure Operator page is open (in your computer browser)

## Select Environment and Site
* Open the configuration screen by clicking on the icon at the top right corner.
* Select Environment by clicking on blue Change button/link under Environments
* Select Site by clicking on blue Change button/link under Sites
* Click on the Apply button/link at the bottom of the screen.

## Messaging to queue
* Click on Message* Type message and press send
* App offers to select the queue - select the correct queue
* Expect incoming call on the operator side and accept it.
* Message should be sen on the operator side
* Operator can write messages now
* On app side to write a new message, please click an icon in the top right corner
* To end, click cancel or end engagement on the operator side

## Two-way Audio
* Click Engage in app and select your operator
* Expect incoming call on the operator side and accept it
* On Operator side click Start Audi icon (top left corner - first button) and select Two-way option
* You should hear both (device and operator) audio streams on Device and on the Operator side
* To end, click cancel or end engagement on the operator side

## Two-way Video
* Click Engage in app and select your Operator
* Expect incoming call on the Operator side and accept it
* On Operator side click Start Video icon (top left corner - second button) and select Two-way option
* You should see both (device and operator) video images on Device and on the Operator side
* To end, click cancel or end engagement on the operator side

## Screensharing and annotations
* Click Engage in the app and select your Operator
* Expect incoming call on the Operator side and accept it
* On Operator side click Start Screensharing icon (top left corner - third button) and select Ask for visitors Screen
* Device will ask your permission to recod screen - click Record Screen
* You will see the Device screen on the Operator side
* Try draw with the mouse cursor over the Device screen on Operator side.
* See the annotations on a Device screen
* Try to move a device screen and you should see it moves on the Operator side.

# Integration of SalemoveSDK using Carthage

### Integration was validated with 
* XCode 11.6 (`/usr/bin/xcodebuild -version`)
* Swift 5.2.4 (`xcrun swift -version`)
* Carthage 0.34.0 (`carthage version`)

### Integration steps

#### 1) Ensure that SalemoveSDK dependency in your Cartfile specifies version tag
This way you always get the Released state of the SDK

* Example: `github "Salemove/ios-bundle" "0.21.1"`

#### 2) Get and build dependencies
Run `carthage update --platform iOS` to get latest dependencies

Run `carthage bootstrap --platform iOS` to get exact versions specified in Cartfile.resolved file

* if you get swift version incompatibility issue, then please add `--no-use-binaries`, it builds all dependencies locally to ensure compatibility with your environment, however usually carthage rebuilds automatically when it stumbles upon swift version conflicts.
* Rebuilding takes some time to finish.

##### Known issue 1:

* 1) `Skipped building ios-webrtc due to the error`
* 2) `Skipped building ios-bundle due to the error`

Both errors show up because of prebuilt frameworks for *ios-webrtc* and *ios-bundle*. These frameworks already exist and do not need to be built. And as they already exist (in `Carthage/checkouts` directory) then we do not need to worry about these errors.

##### Known issue 2:

```
objc[1315]: Class RTCCVPixelBuffer is implemented in both /System/Library/PrivateFrameworks/WebCore.framework/Frameworks/libwebrtc.dylib (0x1e95f0620) and /private/var/containers/Bundle/Application/2CE8ACA6-BC52-4903-9B8F-DE2DB201570D/ExampleApp.app/Frameworks/WebRTC.framework/WebRTC (0x105c5d690). One of the two will be used. Which one is undefined.
```
* [https://bugs.chromium.org/p/webrtc/issues/detail?id=10560](https://bugs.chromium.org/p/webrtc/issues/detail?id=10560)

NOTE: If the command still fails due to some version mismatch or incompatibility issues, then try deleting the `Cartfile.resolved` file and `Carthage` directory and run the command again.

#### 3) Link built libraries
Carthage update command pulls and builds dependencies into *Carthage* folder.
Pulled files are placed in *Carthage/checkouts* folder and *Carthage/build* files are in *build* folder. There you find different `*.framework` files that need to be linked into your XCode project.

##### To link the files with XCode 11:
* In XCode, click your project in the *Project Navigator*. Select your *target*, choose the *General* tab at the top, and scroll down to the *Frameworks, Libraries, and Embedded Content* section at the bottom.
* Drag and drop all your `*.framework` files (except `RxTest.framework` and any other test related frameworks) from *Carthage/checkouts* and *Carthage/build* folders to that section in XCode.
	* Current full list of frameworks that can be ignored from *Carthage/build* and *Carthage/checkouts* folder
    	* `RxTest.framework`
    	* `RxMoya.framework`
    	* `RxBlocking.framework`
    	* `RxCocoa.framework`
    	* `RxSwift.framework`
    	* `RxRelay.framework`
    	* `ReactiveMoya.framework`
* Go to *Build Settings* and search *Framework Search Paths* to find that section in settings. Doubleclick on its value and validate that these search paths are present. (If they are missing then please add.)
	* `$(inherited)`
	* `$(PROJECT_DIR)/Carthage/Build/iOS`
	* `$(PROJECT_DIR)/Carthage/Checkouts/ios-webrtc/output/bitcode`
	* `$(PROJECT_DIR)/Carthage/Checkouts/ios-bundle`
##### Stripping the frameworks for archiving and distributing:
* Go to *Build Phases* and add a [Run Script](https://help.apple.com/xcode/mac/11.4/#/dev50bab713d) with code `carthage copy-frameworks` which strips the extra architectures
* Add links to all frameworks into *Input files* section
	* `$(SRCROOT)/Carthage/Checkouts/ios-bundle/SalemoveSDK.framework`
	* `$(SRCROOT)/Carthage/Checkouts/ios-webrtc/output/bitcode/WebRTC.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/Alamofire.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/Moya.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/Macaw.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/ObjectMapper.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/ReactiveSwift.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/SocketIO.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/Starscream.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/SwiftPhoenixClient.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/SWXMLHash.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/TwilioVoice.framework`

###### NOTE 1
This is required due Apple bug [http://www.openradar.me/radar?id=6409498411401216](http://www.openradar.me/radar?id=6409498411401216)

###### NOTE 2
Even though carthage does the stripping then for some specific usecases it may not suite well as carthage leaves two slices of architectures inside (armv7s and arm64), so if you are developing specifically for arm64 then the frameworks will carry a little extra weight due that limitation. So if this issue becomes a concern then developers need to find a custom solution to overcome this limitation.

* Note, that when the App is finally in AppStore, Apple will basically "rebuild" your binary into separate variants for each device. [https://help.apple.com/xcode/mac/current/#/devbbdc5ce4f](https://help.apple.com/xcode/mac/current/#/devbbdc5ce4f)
```
The App Store will create and deliver different variants based on the devices your app supports.
```
So having more slices in archived framework should not be a problem.

##### To link the files with older XCode:
* In XCode, click your project in the [*Project Navigator*](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/NavigatingYourWorkspace.html#//apple_ref/doc/uid/TP40010215-CH26-SW1). Select your [*target*](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/WorkingwithTargets.html#//apple_ref/doc/uid/TP40010215-CH32-SW1), choose the *General* tab at the top, and scroll down to the *Linked Frameworks and Libraries* section at the bottom.
* Drag and drop all your `*.framework` files (except `RxTest.framework` and any other test related frameworks) from *Carthage/checkouts* and *Carthage/build* folders to that section in XCode.

### For more specific information please see latest Carthage documentation
* [https://github.com/Carthage/Carthage#adding-frameworks-to-an-application](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)

# Integration of SalemoveSDK using Cocoapods

* Include following pods in your Podfile





