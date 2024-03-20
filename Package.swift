// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GliaSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GliaSDK",
            targets: ["GliaSDK"])
    ],
    targets: [
        .binaryTarget(
            name: "GliaCoreDependency",
            url: "https://github.com/salemove/ios-bundle/releases/download/1.3.5/GliaCoreDependency.xcframework.zip",
            checksum: "a7ca12542bc8470af16632311e96a1925f102e0ee6d36f5c86e422aebe655af1"
        ),
        .binaryTarget(
            name: "TwilioVoice",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.33.0/TwilioVoice.xcframework.zip",
            checksum: "34288e0876a8840fa51d3813046cf1f40a5939079bea23ace5afe6e752f12f9e"
        ),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/stasel/WebRTC/releases/download/119.0.0/WebRTC-M119.xcframework.zip",
            checksum: "60737020738e76f2200f3f2c12a32f260d116f858a2e1ff33c48973ddd3e1c97"
        ),
        .binaryTarget(
            name: "GliaCoreSDK",
            url: "https://github.com/salemove/ios-bundle/releases/download/1.4.1/GliaCoreSDK.xcframework.zip",
            checksum: "c450ec23b68848b6d3c1a8d80f41b33a00db17cead80968c1e9e6b5907ff640e"
        ),
        .target(
            name: "GliaSDK",
            dependencies: [
                "GliaCoreSDK",
                "GliaCoreDependency",
                "TwilioVoice",
                "WebRTC"
            ]
        )
    ]
)
