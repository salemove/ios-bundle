//
//  TVORemoteTrackStats.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import "TVOBaseTrackStats.h"

/**
 * `TVORemoteTrackStats` represents stats common to remote tracks.
 */
NS_SWIFT_NAME(RemoteTrackStats)
@interface TVORemoteTrackStats : TVOBaseTrackStats

/**
 * @brief Total number of bytes received.
 */
@property (nonatomic, assign, readonly) int64_t bytesReceived;

/**
 * @brief Total number of packets received.
 */
@property (nonatomic, assign, readonly) NSUInteger packetsReceived;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Remote track stats cannot be created explicitly.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVORemoteTrackStats cannot be created explicitly.")));

@end
