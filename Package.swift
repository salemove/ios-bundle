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
            targets: ["GliaSDK"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/salemove/opentelemetry-swift.git", .revision("baa983d7b790cde47a3b338b72ede7e44f9770d0")),
    ],
    targets: [
        .binaryTarget(
            name: "GliaCoreDependency",
            url: "https://github.com/salemove/ios-bundle/releases/download/2.1.5/GliaCoreDependency.xcframework.zip",
            checksum: "e1167125f79667a360aa61dffefcb2cbfae56a85cc7ef0571bb033129186d1ce"
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
            url: "https://github.com/salemove/ios-bundle/releases/download/2.2.3/GliaCoreSDK.xcframework.zip",
            checksum: "195040645748ec7232a1c0ab7c9a82a05226f99a921d66ac0dfd7210a3c050d9"
        ),
         .binaryTarget(
            name: "GliaOpenTelemetry",
            url: "https://github.com/salemove/ios-bundle/releases/download/2.1.5/GliaOpenTelemetry.xcframework.zip",
            checksum: "4b407063fef1265bb4c14d230a99fe7c90a45cb74730d47aad4bd63f838345e6"
        ),
        .target(
            name: "GliaSDK",
            dependencies: [
                "GliaCoreSDK",
                "GliaCoreDependency",
                "TwilioVoice",
                "WebRTC",
                "GliaOpenTelemetry"
            ]
        )
    ]
)
