---
layout: post
title: "Enhancing your iOS application with SalemoveSDK"
categories: ios-sdk
tags: ios-sdk guide
author: Dmitry Preobrazhenskiy
---

Please find documentation on how to integrate SaleMove Engagement into your iOS app below.

## Prerequisites

This tutorial is written for:

- Xcode 9.1
- Swift 4.0
- SalemoveSDK 0.7.1

## Introduction

*SalemoveSDK* is a swift library with closed source that comes with a well-documented API and ability to install it using modern dependency management systems such as [CocoaPods][0]

## Integration

In order to provide a user of your application with Engagement capabilities few steps are needed:

1. [Configure the SaleMove Client](#configure-the-salemove-client)
2. [Create Interactable](#create-interactable)
3. [Queue for an Engagement](#queue-for-an-engagement)
4. [Select an Operator for an Engagement](#select-an-operator-for-an-engagement)
5. [Send a chat message](#send-a-chat-message)

## Configure the SaleMove Client

Import *SalemoveSDK* module to the AppDelegate and create a strong instance of the `SalemoveAppDelegate`

```swift
import UIKit
import SalemoveSDK

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?
    let salemoveDelegate = SalemoveAppDelegate()
}

```
Notify the SaleMove client when your application has finished initializing so It can start its bootstrapping process:

```swift
extension AppDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        salemoveDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
}
```

Notify the SaleMove client when your application registers for remote notifications so it can handle its internal push services:

```swift
extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        salemoveDelegate.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
}
```
Notify the SaleMove client when your application becomes active by using the following example so it can handle its internal communication services:

```swift
extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
        salemoveDelegate.applicationDidBecomeActive(application)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}
```

Configure client settings, specifying your Site ID and App Token.

```swift
func configureSalemove() {
  try? Salemove.sharedInstance.configure(site: "72bd8093-eae1-4f31-88c1-0c3132eb0906")
  try? Salemove.sharedInstance.configure(appToken: "sEQaZ6S2ULiFGK9F")
}
```

## Create Interactable

`Interactable` is a protocol to which any object should conform to but it's better to have `UIViewController` as this role.

Here is an example how a controller could be implemented:

```swift
extension UIViewController: Interactable {
    func start() {
        // Remove any spinners or activity indicators and proceed with the flow
        endLoading()
    }

    func end() {
        // Remove any active sessions and do a cleanup and maybe dismiss the controller
        cleanup()
    }

    func fail(with reason: String?) {
        // Handle the failing Engagement request and maybe log the reason or show it to the user
        if let reason = reason {
            print(reason)
        }
        cleanup()
    }

    func receive(message: Message) {
        // Update the messages that are coming from the SDK and show them to to the user
        showMessage(message)
    }

    func handleOperators(operators: [Operators]) {
        // Remove any spinners or activity indicators and proceed with the flow of selecting an Operator
        endLoading()

        let controller = UIAlertController(title: "Operators", message: "Please select", preferredStyle: .actionSheet)

        for availableOperator in operators {
            let action = UIAlertAction(title: availableOperator.name, style: .default) { action in
                // Select an Operator and pass it to the client library
                Salemove.sharedInstance.requestEngagement(with: availableOperator) { [unowned self] engagementRequest, error in
                    self.engagementRequest = engagementRequest
                    // Handle the error as you wish
                    if let reason = error?.reason {
                        self.showError(message: reason)
                    }
                }
            }
            controller.addAction(action)
        }

        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            self.cleanup()
        }))

        present(controller, animated: true, completion: nil)
    }
}
```

## Queue For An Engagement

In order to queue for an Engagement, pass an `Interactable` object to SaleMove client and call `queueForEngagement` to start the flow:

```swift
Salemove.sharedInstance.queueForEngagement(queueID: String, completion: @escaping SalemoveSDK.QueueTicketBlock)
```

for example:

```swift
// Interactor should conform to Interactable protocol
let interactor = UIViewController()
Salemove.sharedInstance.configure(interactor: interactor)
Salemove.sharedInstance.queueForEngagement(queueID: "37116478-04c5-49fb-aa5c-a31e53699221") { _, _ in
   self.present(interactor, animated: true)
}
```

## Select An Operator for an Engagement

In the [example](#create-interactable) you can see how the SaleMove client is passing the operator list to the `Interactable`.

In order to select an Operator, pass one of the available operators to the SaleMove client:

```swift

Salemove.sharedInstance.requestEngagement(with: availableOperator)  { request, error in
 if let error = error {
   // Handle the error
 } else if let request = request {
   // Continue the flow
 }
}
```

## Send A Chat Message

Send a chat message to a queue (with an active engagement):
```swift
Salemove.sharedInstance.send(message: String, completion: @escaping SalemoveSDK.MessageBlock)
```

Example:

```swift
  func composeMessage() {
    let inputController = UIAlertController(title: "Message", message: "Please specify", preferredStyle: .alert)
    inputController.addTextField { textfield in
        textfield.clearButtonMode = .whileEditing
        textfield.borderStyle = .roundedRect
    }

    let confirm = UIAlertAction(title: "Send", style: .default) {
        action in
        if let message = inputController.textFields?.first?.text, !message.isEmpty {
            let completion: MessageBlock = { [unowned self] incomingMessage, error in
                if let error = error {
                    self.showError(message: error.reason)
                } else if let incoming = incomingMessage {
                    // Update incoming messages
                    self.update(with: incoming)
                }
            }

            Salemove.sharedInstance.send(message: message, completion: completion)
        }
    }

    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

    inputController.addAction(confirm)
    inputController.addAction(cancel)

    present(inputController, animated: true, completion: nil)
}
```

Send a chat message to a queue (without an active engagement):
```swift
Salemove.sharedInstance.send(message: String, queueID: String, completion: @escaping SalemoveSDK.MessageBlock)
```

Example:

```swift
  func queueMessage() {
    let interactor = UIViewController()
    Salemove.sharedInstance.configure(interactor: interactor)

    let inputController = UIAlertController(title: "Message", message: "Please specify", preferredStyle: .alert)
    inputController.addTextField { textfield in
        textfield.clearButtonMode = .whileEditing
        textfield.borderStyle = .roundedRect
    }

    let confirm = UIAlertAction(title: "Send", style: .default) {[unowned self] action in
        if let message = inputController.textFields?.first?.text, !message.isEmpty {
            Salemove.sharedInstance.send(message: message, queueID: "37116478-04c5-49fb-aa5c-a31e53699221") { _, _ in
                self.present(interactor, animted: true)
            }
        }
    }

    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

    inputController.addAction(confirm)
    inputController.addAction(cancel)

    present(inputController, animated: true, completion: nil)
}
```

## Engagement End

In order to end an Engagement, use:

```swift
Salemove.sharedInstance.endEngagement()
```

## Special Cases

### Engagement Request Declined

After the Visitor has selected an Operator, the Operator can accept or decline the incoming request. In the case the Operator declines it the `Interactable` will receive a call with reason **rejected**:

```swift
func fail(with reason: String?)
```

### Engagement Request Timeout

After the Visitor has selected an Operator, there is a time during which the Operator needs to accept the incoming request. In the case the request times out the `Interactable` will receive a call with reason **time_out**:

```swift
func fail(with reason: String?)
```

## Demo

[EMI Calculator][1] with the SalemoveSDK integration is also available as an example.

[0]: https://cocoapods.org
[1]: https://github.com/salemove/ios-integration-demo
