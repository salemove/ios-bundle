//
//  TVORemoteAudioTrackStats.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import "TVORemoteTrackStats.h"

/**
 * `TVORemoteAudioTrackStats` represents stats about a remote audio track.
 */
NS_SWIFT_NAME(RemoteAudioTrackStats)
@interface TVORemoteAudioTrackStats : TVORemoteTrackStats

/**
 * @brief Audio output level.
 */
@property (nonatomic, assign, readonly) NSUInteger audioLevel;

/**
 * @brief Packet jitter measured in milliseconds.
 */
@property (nonatomic, assign, readonly) NSUInteger jitter;

/**
   @brief The Mean Opinion Score (MOS). This is a measure of the call audio quality.

   @discussion The Mean Opinion Score (MOS) represents the call audio quality where a score of 5 represents
   the best audio possible, for example, real world face to face speech, and 1 represents audio quality that is unintelligible.
   Typically, a score of 3.5 or below for a few seconds becomes annoying to the user. The score is calculated using [Vincenty's formulae](https://en.wikipedia.org/wiki/Vincenty%27s_formulae) once
   per second and uses `jitter`, `rtt`, and `packet loss` values to perform the calculation. The following table describes
   how MOS relates to quality:
 
   <table border="1" summary="mos">
   <tr>
   <td>MOS Range</td><td>Perceived Quality</td>
   </tr>
   <tr>
   <td>>= 4.2</td><td>Excellent</td>
   </tr>
   <tr>
   <td>4.1 - 4.2</td><td>Great</td>
   </tr>
   <tr>
   <td>3.7 - 4.0</td><td>Good</td>
   </tr>
   <tr>
   <td>3.1 - 3.6</td><td>Almost unintelligible</td>
   </tr>
   <tr>
   <td>< 3.1</td><td>Degraded/Unacceptable</td>
   </tr>
   </table>
 */
@property (nonatomic, assign, readonly) double mos;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Remote audio track stats cannot be created explicitly.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVORemoteAudioTrackStats cannot be created explicitly.")));

@end
