//
//  TVODefaultAudioDevice.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "TVOAudioDevice.h"

static NSTimeInterval const kTVODefaultAudioDeviceIOBufferDurationSimulator = 0.02;
static double const kTVODefaultAudioDeviceSampleRateSimulator = 48000;

/**
 *  `TVOAVAudioSessionConfigurationBlock` allows you to configure AVAudioSession.
 */
typedef void (^TVOAVAudioSessionConfigurationBlock)(void)
NS_SWIFT_NAME(DefaultAudioDevice.AVAudioSessionConfigurationBlock);

/**
 *  `kTVODefaultAVAudioSessionConfigurationBlock` configures AVAudioSession with the default values for a bidirectional
 *  VOIP audio call.
 */
NS_SWIFT_NAME(DefaultAudioDevice.DefaultAVAudioSessionConfigurationBlock)
static TVOAVAudioSessionConfigurationBlock _Nonnull kTVODefaultAVAudioSessionConfigurationBlock = ^() {
    AVAudioSession *session = [AVAudioSession sharedInstance];

    NSError *error = nil;
    if (@available(iOS 10.0, *)) {
        if ([session respondsToSelector:@selector(setCategory:mode:options:error:)]) {
            if (![session setCategory:AVAudioSessionCategoryPlayAndRecord
                                 mode:AVAudioSessionModeVoiceChat
                              options:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionAllowBluetoothA2DP
                                error:&error]) {
                NSLog(@"AVAudioSession setCategory:options:mode:error: %@",error);
            }
        }
    } else {
        if (![session setCategory:AVAudioSessionCategoryPlayAndRecord
                      withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                            error:&error]) {
            NSLog(@"AVAudioSession setCategory:withOptions:error: %@",error);
        }

        if (![session setMode:AVAudioSessionModeVoiceChat error:&error]) {
            NSLog(@"AVAudioSession setMode:error: %@",error);
        }
    }

#if TARGET_IPHONE_SIMULATOR
    // Workaround for issues using 48 khz / 10 msec on the simulator: https://bugs.chromium.org/p/webrtc/issues/detail?id=6644
    double sampleRate = kTVODefaultAudioDeviceSampleRateSimulator;
    double ioBufferDuration = kTVODefaultAudioDeviceIOBufferDurationSimulator;
#else
    // In WebRTC-67 a 20 msec duration is preferred with the default device.
    double sampleRate = 48000;
    double ioBufferDuration = 0.02;
#endif
    if (![session setPreferredSampleRate:sampleRate error:&error]) {
        NSLog(@"AVAudioSession setPreferredSampleRate:error: %@",error);
    }
    if (![session setPreferredIOBufferDuration:ioBufferDuration error:&error]) {
        NSLog(@"AVAudioSession setPreferredIOBufferDuration:error: %@",error);
    }

    // Make sure AVAudioSession is not activated while configuring the aggregatedIOPreference.

    if (@available(iOS 10.0, *)) {
        if ([[AVAudioSession sharedInstance] respondsToSelector: @selector(setAggregatedIOPreference:error:)]) {
            if (![session setAggregatedIOPreference:AVAudioSessionIOTypeAggregated error:&error]) {
                NSLog(@"AVAudioSession setAggregatedIOPreference:error: %@",error);
            }
        }
    }
    
    /*
     * You should not set `preferredInputNumberOfChannels` and `preferredOutputNumberOfChannels` until the
     * AVAudioSession is activated. Since this block will be called before and after activation, we first check the
     * maximum number of channels before setting our preferences. `TVODefaultAudioDevice` configures an AudioUnit graph
     * which uses mono I/O, but adapts to the current sample rate.
     */
    if (session.maximumInputNumberOfChannels > 0 &&
        ![session setPreferredInputNumberOfChannels:1 error:&error]) {
        NSLog(@"AVAudioSession setPreferredInputNumberOfChannels:error: %@", error);
    }
    if (session.maximumOutputNumberOfChannels > 0 &&
        ![session setPreferredOutputNumberOfChannels:1 error:&error]) {
        NSLog(@"AVAudioSession setPreferredOutputNumberOfChannels:error: %@", error);
    }
};

/**
 *  `TVODefaultAudioDevice` allows you to record and playback audio when you are connected to a Call.
 */
NS_SWIFT_NAME(DefaultAudioDevice)
@interface TVODefaultAudioDevice : NSObject <TVOAudioDevice>

/**
   @brief A block to configure the AVAudiosession.

   @discussion  If `TVODefaultAudioDevice` is `enabled`, the SDK executes this block and activates the audio session while
   connecting to a Call, otherwise it is the developer's responsibility to execute the block. Please note that the getter of
   this property returns a wrapper block which internally executes the block you set. By default, the SDK returns a default
   wrapper block which executes `kTVODefaultAVAudioSessionConfigurationBlock` internally.

   The following example demonstrates changing the audio route from speaker to receiver:

      TVODefaultAudioDevice *audioDevice = [TVODefaultAudioDevice audioDevice];

      TwilioVoiceSDK.audioDevice = audioDevice;

      //...connect to a Call with audioDevice. By default the audio route will be configured to receiver.

      audioDevice.block =  ^ {
          // We will execute `kTVODefaultAVAudioSessionConfigurationBlock` first.
          kTVODefaultAVAudioSessionConfigurationBlock();

          // Overwrite the audio route
          AVAudioSession *session = [AVAudioSession sharedInstance];
          NSError *error = nil;
          if (![session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error]) {
              NSLog(@"AVAudiosession overrideOutputAudioPort %@",error);
          }
      };
      audioDevice.block();
 */
@property (nonatomic, copy, nonnull) TVOAVAudioSessionConfigurationBlock block;

/**
 *  @brief A boolean which enables playback and recording.
 *
 *  @discussion By default, the SDK initializes this property to YES. Setting it to NO forces the underlying CoreAudio
 *  graph to be stopped (if active), and prevents it from being started again. Setting the property to YES allows the
 *  audio graph to be started whenever there is audio to play or record in a Call.
 */
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Use `defaultAudioDevice`to create a `TVODefaultAudioDevice`.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("Use `audioDevice` to create a `TVODefaultAudioDevice`.")));

/**
 *  @brief Factory method to create an instance of `TVODefaultAudioDevice`.
 */
+ (nonnull instancetype)audioDevice;

/**
   @brief Factory method with a block to create an instance of `TVODefaultAudioDevice`.
   @param block The AVAudioSession configuration block.
   @return An instance of TVODefaultAudioDevice.

   @discussion Use this factory method if you want to connect to a Call with your choice of audio session configuration.
 
   The following example demonstrates connecting to a Call using the AVAudioSessionCategoryPlayback category:

      TwilioVoiceSDK.audioDevice = [TVODefaultAudioDevice audioDeviceWithBlock:^ {
          // We will execute `kTVODefaultAVAudioSessionConfigurationBlock` first.
          kTVODefaultAVAudioSessionConfigurationBlock();

          // Overwrite the category to `playback`
          AVAudioSession *session = [AVAudioSession sharedInstance];
          NSError *error = nil;
          if (![session setCategory:AVAudioSessionCategoryPlayback
                               mode:AVAudioSessionModeVoiceChat
                            options:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionAllowBluetoothA2DP
                              error:&error]) {
              NSLog(@"AVAudioSession setCategory:options:mode:error: %@",error);
          }
      }];

      TVOConnectOptions *connectOptions = [TVOConnectOptions optionsWithToken:token
                                                                        block:^(TVOConnectOptionsBuilder *builder) {
          // configure builder attributes here
      }];

      TVOCall *call = [TwilioVoiceSDK connectWithOptions:connectOptions];
 */
+ (nonnull instancetype)audioDeviceWithBlock:(TVOAVAudioSessionConfigurationBlock _Nonnull )block;

@end
