//
//  TVOIceOptions.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  `TVOIceTransportPolicy` specifies which ICE transports to allow.
 */
typedef NS_ENUM(NSUInteger, TVOIceTransportPolicy) {
    TVOIceTransportPolicyAll = 0,   ///< All transports will be used.
    TVOIceTransportPolicyRelay = 1  ///< Only TURN relay transports will be used.
}
NS_SWIFT_NAME(IceOptions.IceTransportPolicy);

/**
 *  `TVOIceServer` is a single STUN or TURN server.
 */
NS_SWIFT_NAME(IceServer)
@interface TVOIceServer : NSObject

/**
 *  @brief The URL string for the ICE server.
 *
 *  @discussion Your server URL must begin with either the stun: or turn: scheme.
 *  For example, a STUN server could be defined as <stun:stun.company.com:port>.
 */
@property (nonnull, nonatomic, readonly, copy) NSString *urlString;

/**
 *  @brief The user name. Required for TURN servers.
 */
@property (nullable, nonatomic, readonly, copy) NSString *username;

/**
 *  @brief The password. Required for TURN servers.
 */
@property (nullable, nonatomic, readonly, copy) NSString *password;

/**
 *  Creates a `TVOIceServer`.
 *
 *  @param serverURLString The URL for your STUN or TURN server.
 *
 *  @return A `TVOIceServer` object.
 */
- (null_unspecified instancetype)initWithURLString:(nonnull NSString *)serverURLString;

/**
 *  Creates a `TVOIceServer`.
 *
 *  @param serverURLString The URL for your STUN or TURN server.
 *  @param username The username credential for your server.
 *  @param password The password credential for your server.
 *
 *  @return A `TVOIceServer` object.
 */
- (null_unspecified instancetype)initWithURLString:(nonnull NSString *)serverURLString
                                          username:(nullable NSString *)username
                                          password:(nullable NSString *)password;

/**
 *  @brief Developers should initialize with a parameterized initializer.
 *
 *  @discussion `TVOIceServer` cannot be created without supplying parameters.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVOIceServer must be created with a parameterized initializer.")));

@end

/**
 *  @brief `TVOIceOptionsBuilder` constructs `TVOIceOptions`.
 *
 *  @discussion If you provide a `transportPolicy` but do not provide any ICE Servers, then the servers will automatically
 *  be fetched for you based upon how the Call was created. For Client created Calls the default Call settings
 *  are used, while settings are provided on a per-Call basis when creating Calls using the REST API.
 */
NS_SWIFT_NAME(IceOptionsBuilder)
@interface TVOIceOptionsBuilder : NSObject

/**
 *  @brief An array of `TVOIceServer` objects to be used during connection establishment.
 */
@property (nonatomic, strong, nullable) NSArray<TVOIceServer *> *servers;

/**
 *  @brief The transport policy to use. Defaults to `TVOIceTransportPolicyAll`.
 */
@property (nonatomic, assign) TVOIceTransportPolicy transportPolicy;

- (null_unspecified instancetype)init __attribute__((unavailable("Use a TVOIceOptionsBuilderBlock instead.")));

@end

/**
 *  `TVOIceOptionsBuilderBlock` is a block to configure ICE options.
 *
 *  @param builder The builder
 */
typedef void (^TVOIceOptionsBuilderBlock)(TVOIceOptionsBuilder * _Nonnull builder)
NS_SWIFT_NAME(IceOptionsBuilder.Block);

/**
 *  `TVOIceOptions` specifies custom media connectivity configurations.
 *
 *  @discussion Media connections are established using the ICE (Interactive Connectivity Establishment) protocol.
 *  These options allow you to customize how data flows to and from participants, and which protocols to use.
 *  You may also provide your own ICE servers, overriding the defaults.
 *  https://www.twilio.com/stun-turn
 */
NS_SWIFT_NAME(IceOptions)
@interface TVOIceOptions : NSObject

/**
 *  An array of `TVOIceServer` objects to be used during connection establishment.
 */
@property (nonatomic, copy, nonnull, readonly) NSArray<TVOIceServer *> *servers;

/**
 *  The transport policy to use. Defaults to `TVOIceTransportPolicyAll`.
 */
@property (nonatomic, assign, readonly) TVOIceTransportPolicy transportPolicy;

/**
 *  @brief Creates a default `TVOIceOptions` instance.
 *
 *  @return An instance of `TVOIceOptions`.
 */
+ (_Null_unspecified instancetype)options;

/**
 *  @brief Creates a `TVOIceOptions` instance using a builder block that you specify.
 *
 *  @param block A `TVOIceOptionsBuilderBlock` which sets specific options on the builder.
 *
 *  @return A `TVOIceOptions` instance created using options set in the builder block.
 */
+ (nonnull instancetype)optionsWithBlock:(nonnull TVOIceOptionsBuilderBlock)block;

@end
