// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GliaSDK",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "GliaSDK",
            targets: ["GliaSDK"])
    ],
    targets: [
        .binaryTarget(
            name: "TwilioVoice",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.27.0/TwilioVoice.xcframework.zip",
            checksum: "039b38797721ed272abdb69780cd3239961786d94175b6846036dad4c4a5b636"
        ),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.27.0/WebRTC.xcframework.zip",
            checksum: "996f02aff0f0ade1a16f0d8798150e58a126934ebdfd20610421931bfa459859"
        ),
        .binaryTarget(
            name: "SalemoveSDK",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.29.5/SalemoveSDK.xcframework.zip",
            checksum: "2714698fbc7bbaa04a96e46d90717f2a5f79990eee7e0d76fddf581563b643d7"
        ),
        .target(
            name: "GliaSDK",
            dependencies: [
                "SalemoveSDK",
                "TwilioVoice",
                "WebRTC"
            ]
        )
    ]
)
