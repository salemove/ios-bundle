// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GliaSDK",
    platforms: [
        .iOS("15.1")
    ],
    products: [
        .library(
            name: "GliaSDK",
            targets: ["GliaSDK"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/salemove/opentelemetry-swift.git", .revision("baa983d7b790cde47a3b338b72ede7e44f9770d0"))
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
            url: "https://github.com/salemove/ios-bundle/releases/download/2.3.2/GliaCoreSDK.xcframework.zip",
            checksum: "e5dd9643a3074b9ac1c28ff4f8dec870412ed1e83a3f12bca388a5ffe8725e43"
        ),
        .binaryTarget(
            name: "GliaOpenTelemetry",
            url: "https://github.com/salemove/ios-telemetry-bundle/releases/download/1.0.7/GliaOpenTelemetry.xcframework.zip",
            checksum: "3fd7e77fdd49448c13c57752a7fab0d7ee9ae1d9f4d972bfed815f0ffc963278"
        ),
        .binaryTarget(
            name: "PhoenixChannelsClient",
            url: "https://github.com/salemove/ios-bundle/releases/download/2.1.5/PhoenixChannelsClient.xcframework.zip",
            checksum: "5c6bff89a535d4ecf58ac26f221953b80772f2ae1680e01aa1fa1802743233e8"
        ),
        .target(
            name: "GliaSDK",
            dependencies: [
                "GliaCoreSDK",
                "GliaCoreDependency",
                "TwilioVoice",
                "WebRTC",
                "PhoenixChannelsClient",
                "GliaOpenTelemetry"
            ]
        )
    ]
)
