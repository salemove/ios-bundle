//
//  TVOAudioCodec.h
//  TwilioVoice
//
//  Copyright © 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * `TVOAudioCodec` is the base class for all supported audio codecs.
 */
NS_SWIFT_NAME(AudioCodec)
@interface TVOAudioCodec : NSObject

/**
 *  @brief The name of the audio codec.
 */
@property (nonatomic, copy, readonly, nonnull) NSString *name;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion `TVOAudioCodec` can not be created with init. To use an audio codec, use one of the `TVOAudioCodec` subclasses.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVOAudioCodec can not be created explicitly. Use a TVOAudioCodec subclass")));

@end
