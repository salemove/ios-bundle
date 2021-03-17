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
            name: "Alamofire",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.27.0/Alamofire.xcframework.zip",
            checksum: "38e51133ea91f33aa933eeabe52c066a2e4ef9aa4716163e33975cf326289a55"
        ),
        .binaryTarget(
            name: "Macaw",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.27.0/Macaw.xcframework.zip",
            checksum: "474bbf16a032927225c21a58626a90b18369d628ab9a25f438a8ec2043c478cb"
        ),
        .binaryTarget(
            name: "Moya",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.27.0/Moya.xcframework.zip",
            checksum: "8c1c501966d6dc4124ef9166b6687dce79ad3cbd98d1533eafaa8648b94ade40"
        ),
        .binaryTarget(
            name: "ReactiveSwift",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.27.0/ReactiveSwift.xcframework.zip",
            checksum: "f1322d3e07b01a4f2b1329b7ed43494259fba740c666231422b373ec50dc1e7d"
        ),
        .binaryTarget(
            name: "SocketIO",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.27.0/SocketIO.xcframework.zip",
            checksum: "119a21a9d7d0b9a20b0705e5c639cb57cc1d93ee08874a89dd53b8ca23905ad6"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.27.0/Starscream.xcframework.zip",
            checksum: "74c26814b5b9dac878a4d7a4012d4d496c498d6066375d0cf7ee65a1c435cd2c"
        ),
        .binaryTarget(
            name: "SwiftPhoenixClient",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.27.0/SwiftPhoenixClient.xcframework.zip",
            checksum: "a4393ea48dd0502a5495c38408f0d49b4e6b6345765cf569a2037acfe04a4340"
        ),
        .binaryTarget(
            name: "SWXMLHash",
            url: "https://github.com/salemove/ios-bundle/releases/download/0.27.0/SWXMLHash.xcframework.zip",
            checksum: "fbeb88db6565c7843d6ee5f4e64d1030b1ebcc7fa7ca4b66e9ec1af56d1ad199"
        ),
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
            url: "https://github.com/salemove/ios-bundle/releases/download/0.28.0/SalemoveSDK.xcframework.zip",
            checksum: "eceeec40cfa574e4da549fa4a2635819af406f6b9c2055685f11ba871a619289"
        ),
        .target(
            name: "GliaSDK",
            dependencies: [
                "SalemoveSDK",
                "Alamofire",
                "Moya",
                "Macaw",
                "ReactiveSwift",
                "SocketIO",
                "SwiftPhoenixClient",
                "Starscream",
                "SWXMLHash",
                "TwilioVoice",
                "WebRTC"
            ]
        )
    ]
)
