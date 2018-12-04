# Frequently Asked Questions

This is a list of questions we frequently get and problems that are often encountered. 

* [Example app not compiling](#example-app-not-compiling)
* [Why do we include a custom socket.io library](#why-do-we-include-a-custom-socket-library)

## Example app not compiling

There is an Example app where the SDK is integrated using cocoapods. After checking out
the repository please remember to do 'pod install' to get all the dependencies. After that open the 
Example.xcworkspace and run the app.

## Why do we include a custom socket library?

The socket.io-client-swift we use no longer support socket 1.0 [so you need to include the 
pod by specifying repository and branch.](https://github.com/socketio/socket.io-client-swift/pull/1125)