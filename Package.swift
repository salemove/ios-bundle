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
            url: "https://github.com/salemove/ios-bundle/releases/download/0.35.0/GliaCoreDependency.xcframework.zip",
            checksum: "8e1746da612dad8a130fd872b3058511121b7c6f29e3b0351ecbbffa96971489"
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
            url: "https://github.com/salemove/ios-bundle/releases/download/1.3.3/GliaCoreSDK.xcframework.zip",
            checksum: "63b691ee44da15611edc7054a1d4eaa66de5cd770b045dddd708c37eb76360c8"
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
