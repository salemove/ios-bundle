//
//  TVOCallOptions.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import "TVOAudioCodec.h"
#import "TVOIceOptions.h"

#pragma mark - TVOCallOptionsBuilder

/**
 *  `TVOCallOptionsBuilder` is a builder class for `TVOCallOptions`.
 */
NS_SWIFT_NAME(CallOptionsBuilder)
@interface TVOCallOptionsBuilder : NSObject

/**
 *  @brief The queue where the Call and associated classes will invoke delegate methods.
 *
 *  @discussion All delegate methods are performed on this queue. Any `TVOCall` instance
 *  which is created with these options will maintain a strong reference to the queue until
 *  it is destroyed.
 *  The default value of `nil` indicates that the main dispatch queue will be used.
 */
@property (nonatomic, strong, nullable) dispatch_queue_t delegateQueue;

/**
 *  @brief A custom ICE configuration used to connect to a Call.
 */
@property (nonatomic, strong, nullable) TVOIceOptions *iceOptions;

/**
 * @brief The collection of preferred audio codecs.
 *
 * @discussion The list specifies which audio codecs will be preferred when negotiating audio between participants.
 * The preferences are applied in the order found in the list starting with the most preferred audio codec to the
 * least preferred audio codec. Audio codec preferences are not guaranteed to be satisfied because not all participants
 * are guaranteed to support all audio codecs. `TVOOpusCodec` is the default audio codec if no preferences are set.
 */
@property (nonatomic, copy, nonnull) NSArray<TVOAudioCodec *> *preferredAudioCodecs;

/**
 * @brief Enables Differentiated Services Field Code Point (DSCP) with Expedited Forwarding (EF).
 * https://tools.ietf.org/html/draft-ietf-tsvwg-rtcweb-qos-18#section-5
 *
 * @discussion DSCP is enabled by default.
 */
@property (nonatomic, assign) BOOL enableDscp;

/**
 * @brief Enable gathering of ICE candidates on "any address" ports. When this flag is set, ports not bound to any
 * specific network interface will be used, in addition to normal ports bound to the enumerated interfaces. This flag may
 * need to be set to support certain network configurations (e.g. some VPN implementations) where ports are not
 * bound to specific interfaces. Setting this flag means that additional candidates might need to be gathered and
 * evaluated, which could lead to slower ICE connection times for regular networks.
 */
@property (nonatomic, assign) BOOL enableIceGatheringOnAnyAddressPorts;

/**
 *  @brief You should not initialize `TVOCallOptionsBuilder` directly, use a `TVOCallOptionsBuilderBlock` instead.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("Use the `TVOConnectOptions` or `TVOAcceptOptions` initializer instead.")));

@end

#pragma mark - TVOCallOptionsBuilder (CallKit)

/**
 *  CallKit specific additions.
 */
@interface TVOCallOptionsBuilder (CallKit)

/**
 *  @brief The CallKit identifier for the Call. You must set this property if you are using CallKit to manage the Call.
 *
 *  @discussion This property allows you to provide your CallKit UUID as part of `TVOConnectOptions` or `TVOAcceptOptions.
 *  This is offered as a convenience if you wish to use `TVOCall` for CallKit book keeping. The UUID set here will be reflected on any
 *  `TVOCall` instance created with these options. 
 */
@property (nonatomic, strong, nullable) NSUUID *uuid;

@end

#pragma mark - TVOCallOptions

/**
 * Represents options available when connecting to a Call. Normally, this class is not used directly.
 * See TVOConnectOptions or TVOCAcceptOptions for example usage.
 */
NS_SWIFT_NAME(CallOptions)
@interface TVOCallOptions : NSObject

/**
 *  @brief The queue where the Call and associated classes will invoke delegate methods.
 *
 *  @discussion All delegate methods are performed on this queue. Any `TVOCall` instance
 *  which is created with these options will maintain a strong reference to the queue until
 *  it is destroyed.
 *  The default value of `nil` indicates that the main dispatch queue will be used.
 */
@property (nonatomic, strong, readonly, nullable) dispatch_queue_t delegateQueue;

/**
 *  @brief A custom ICE configuration used to connect to a Call.
 */
@property (nonatomic, strong, readonly, nullable) TVOIceOptions *iceOptions;

/**
 * @brief The collection of preferred audio codecs.
 *
 * @discussion The list specifies which audio codecs will be preferred when negotiating audio between participants.
 * The preferences are applied in the order found in the list starting with the most preferred audio codec to the
 * least preferred audio codec. Audio codec preferences are not guaranteed to be satisfied because not all participants
 * are guaranteed to support all audio codecs. `TVOOpusCodec` is the default audio codec if no preferences are set.
 */
@property (nonatomic, copy, readonly, nonnull) NSArray<TVOAudioCodec *> *preferredAudioCodecs;

/**
 * @brief Enables Differentiated Services Field Code Point (DSCP) with Expedited Forwarding (EF).
 * https://tools.ietf.org/html/draft-ietf-tsvwg-rtcweb-qos-18#section-5
 *
 * @discussion DSCP is enabled by default.
 */
@property (nonatomic, assign, readonly) BOOL enableDscp;

/**
 * @brief Enable gathering of ICE candidates on "any address" ports. When this flag is set, ports not bound to any
 * specific network interface will be used, in addition to normal ports bound to the enumerated interfaces. This flag may
 * need to be set to support certain network configurations (e.g. some VPN implementations) where ports are not
 * bound to specific interfaces. Setting this flag means that additional candidates might need to be gathered and
 * evaluated, which could lead to slower ICE connection times for regular networks.
 */
@property (nonatomic, assign, readonly) BOOL enableIceGatheringOnAnyAddressPorts;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Use the `TVOConnectOptions` or `TVOAcceptOptions` builder method instead.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("Use the `TVOConnectOptions` or `TVOAcceptOptions` initializer instead.")));

@end

#pragma mark - TVOCallOptions (CallKit)

/**
 *  CallKit specific additions.
 */
@interface TVOCallOptions (CallKit)

/**
 *  @brief The CallKit identifier for the Call. You must set this property if you are using CallKit to manage the Call.
 *
 *  @discussion This property allows you to provide your CallKit UUID as part of `TVOConnectOptions` or `TVOAcceptOptions.
 *  This is offered as a convenience if you wish to use `TVOCall` for CallKit book keeping. The UUID set here will be reflected on any
 *  `TVOCall` instance created with these options.
 */
@property (nonatomic, strong, readonly, nullable) NSUUID *uuid;

@end
