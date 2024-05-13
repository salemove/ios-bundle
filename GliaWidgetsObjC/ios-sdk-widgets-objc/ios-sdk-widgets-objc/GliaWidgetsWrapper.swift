import Foundation
import GliaWidgets

@objc
public enum GliaWidgetsEnvironment: Int {
    case us, eu, beta

    var toSdkEnv: Environment {
        switch self {
        case .us:
            return .usa
        case .eu:
            return .europe
        default:
            return .beta
        }
    }
}

@objc
public enum GliaWidgetsEngagementKind: Int {
    case text, audio, video

    var toSdkKind: EngagementKind {
        switch self {
        case .text:
            return .chat
        case .audio:
            return .audioCall
        case .video:
            return .videoCall
        default:
            return .chat
        }
    }
}

@objcMembers
public class GliaWidgetsWrapper: NSObject {

    public static let sharedInstance = GliaWidgetsWrapper()

    @objc
    public func configure(
        env: GliaWidgetsEnvironment,
        siteId: String,
        siteApiKey: String,
        siteApiKeySecret: String,
        onComplete: @escaping (NSError?) -> Void
    ) throws {
        try Self.sdk.configure(
            with: .init(
                authorizationMethod: .siteApiKey(id: siteApiKey, secret: siteApiKeySecret),
                environment: env.toSdkEnv,
                site: siteId
            ),
            theme: .init(),
            completion: { result in
                switch result {
                case .success:
                    onComplete(nil)
                case .failure(let error):
                    onComplete(NSError(domain: "\(error)", code: 400))
                }
            }
        )
    }

    @objc
    public func startEngagement(
        kind: GliaWidgetsEngagementKind,
        queueId: String
    ) throws {
        try Self.sdk.startEngagement(engagementKind: kind.toSdkKind, in: [queueId])
    }

    @objc
    public func startEngagement(
        kind: GliaWidgetsEngagementKind,
        queueIds: [String]
    ) throws {
        try Self.sdk.startEngagement(engagementKind: kind.toSdkKind, in: queueIds)
    }

    // MARK: - Private

    private static let sdk = Glia.sharedInstance
}
