//
//  TVOPcmuCodec.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import "TVOAudioCodec.h"

/**
 * @brief ITU-T standard for audio companding.
 *
 * @see [PCMU](https://en.wikipedia.org/wiki/G.711)
 */
NS_SWIFT_NAME(PcmuCodec)
@interface TVOPcmuCodec : TVOAudioCodec

/**
 * Initialzes an instance of the `TVOPcmuCodec` codec.
 */
- (null_unspecified instancetype)init;

@end
