//
//  TVOLocalAudioTrackStats.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import "TVOLocalTrackStats.h"

/**
 * `TVOLocalAudioTrackStats` represents stats about a local audio track.
 */
NS_SWIFT_NAME(LocalAudioTrackStats)
@interface TVOLocalAudioTrackStats : TVOLocalTrackStats

/**
 * @brief Audio input level.
 */
@property (nonatomic, assign, readonly) NSUInteger audioLevel;

/**
 * @brief Packet jitter measured in milliseconds.
 */
@property (nonatomic, assign, readonly) NSUInteger jitter;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Local audio track stats cannot be created explicitly.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVOLocalAudioTrackStats cannot be created explicitly.")));

@end
