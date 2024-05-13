//
//  TVOOpusCodec.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import "TVOAudioCodec.h"

/**
 * @brief Lossy audio coding format.
 *
 * @see [Opus](https://en.wikipedia.org/wiki/Opus_(audio_format))
 */
NS_SWIFT_NAME(OpusCodec)
@interface TVOOpusCodec : TVOAudioCodec

/**
 * Initialzes an instance of the `TVOOpusCodec` codec.
 */
- (null_unspecified instancetype)init;

/**
 * Initialzes an instance of the `TVOOpusCodec` codec.
 *
 * @param maxAverageBitrate The maximum average audio bitrate to use, in bits per second (bps)
 * based on [RFC-7587 7.1](https://tools.ietf.org/html/rfc7587#section-7.1). By default, the setting is not used.
 * If you specify 0, then the setting is not used. Any positive integer is allowed, but values outside the range
 * 6000 to 510000 are ignored and treated as 0. The recommended bitrate for speech is between 8000 and 40000 bps
 * as noted in [RFC-7587 3.1.1](https://tools.ietf.org/html/rfc7587#section-3.1.1).
 */
- (null_unspecified instancetype)initWithMaxAverageBitrate:(NSUInteger)maxAverageBitrate;

/**
 * @brief Maximum audio send bitrate in bits per second.
 *
 * @discussion The maximum average audio bitrate to use, in bits per second (bps)
 * based on [RFC-7587 7.1](https://tools.ietf.org/html/rfc7587#section-7.1). By default, the setting is not used.
 * If you specify 0, then the setting is not used. Any positive integer is allowed, but values outside the range
 * 6000 to 510000 are ignored and treated as 0. The recommended bitrate for speech is between 8000 and 40000 bps
 * as noted in [RFC-7587 3.1.1](https://tools.ietf.org/html/rfc7587#section-3.1.1).
 */
@property (nonatomic, assign, readonly) NSUInteger maxAverageBitrate;

@end
