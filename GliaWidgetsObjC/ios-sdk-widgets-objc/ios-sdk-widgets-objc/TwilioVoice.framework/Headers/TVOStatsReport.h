//
//  TVOStatsReport.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

@class TVOLocalAudioTrackStats;
@class TVORemoteAudioTrackStats;
@class TVOIceCandidateStats;
@class TVOIceCandidatePairStats;

/**
 * `TVOStatsReport` contains stats for all tracks associated with a single peer connection.
 */
NS_SWIFT_NAME(StatsReport)
@interface TVOStatsReport : NSObject

/**
 * @brief The id of peer connection related to this report.
 */
@property (nonatomic, copy, readonly, nonnull) NSString *peerConnectionId;

/**
 * @brief The stats for all local audio tracks in the peer connection.
 */
@property (nonatomic, strong, readonly, nonnull) NSArray<TVOLocalAudioTrackStats *> *localAudioTrackStats;

/**
 * @brief The stats for all remote audio tracks in the peer connection.
 */
@property (nonatomic, strong, readonly, nonnull) NSArray<TVORemoteAudioTrackStats *> *remoteAudioTrackStats;

/**
 * @brief The stats for all Ice candidates.
 */
@property (nonatomic, strong, readonly, nonnull) NSArray<TVOIceCandidateStats *> *iceCandidateStats;

/**
 * @brief The stats for all Ice candidates pairs.
 */
@property (nonatomic, strong, readonly, nonnull) NSArray<TVOIceCandidatePairStats *> *iceCandidatePairStats;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Stats report cannot be created explicitly.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVOStatsReport cannot be created explicitly.")));

@end
