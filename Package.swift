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
            url: "https://github.com/salemove/ios-bundle/releases/download/2.6.2/GliaCoreSDK.xcframework.zip",
            checksum: "c7dff11f67fbccfe6a6b22d1ada08fb1ac64dd775d489bf8bf6c938804eebe63"
        ),
        .binaryTarget(
            name: "GliaOpenTelemetry",
            url: "https://github.com/salemove/ios-telemetry-bundle/releases/download/1.0.8/GliaOpenTelemetry.xcframework.zip",
            checksum: "9dd9e68d8312c601a69e73f46adf0132226168baa0e3f21415af47835c4d139d"
        ),
        .binaryTarget(
            name: "PhoenixChannelsClient",
            url: "https://github.com/salemove/phoenix-channels-kmm-bundle/releases/download/1.1.3/PhoenixChannelsClient.xcframework.zip",
            checksum: "ed1396ab1c96d6371b95f45b9c39e33fdcc44dae7180cc58e8cbadcaafac5c03"
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
