//
//  TVOConnectOptions.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import "TVOCallOptions.h"

@class TVOCallInvite;

/**
   `TVOConnectOptionsBuilder` is a builder class for `TVOConnectOptions`.
 
   @discussion Connect options builder to use when connecting. For example:
 
   ```
     let connectOptions = TVOConnectOptions(accessToken: accessToken) { builder in
         builder.params = ["to": "bob"]
         builder.enableIceGatheringOnAnyAddressPorts = true
     }
 
     let call = TwilioVoiceSDK.connect(with: connectOptions, delegate: callDelegate)
   ```
 */
NS_SWIFT_NAME(ConnectOptionsBuilder)
@interface TVOConnectOptionsBuilder : TVOCallOptionsBuilder

/**
 * @brief Additional parameters for connecting the Call.
 *
 * @discussion The Voice SDK URI encodes the parameters before passing them to your TwiML Application.
 */
@property (nonatomic, copy, nonnull) NSDictionary <NSString *, NSString *> *params;

/**
 *  @brief You should not initialize `TVOConnectOptionsBuilder` directly, use a `TVOConnectOptionsBuilderBlock` instead.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("Use a TVOConnectOptionsBuilderBlock instead.")));

@end

/**
 *  `TVOConnectOptionsBuilderBlock` allows you to construct `TVOConnectOptions` using the builder pattern.
 *
 *  @param builder The builder
 */
typedef void (^TVOConnectOptionsBuilderBlock)(TVOConnectOptionsBuilder * _Nonnull builder)
NS_SWIFT_NAME(ConnectOptionsBuilder.Block);

/**
   @brief `TVOConnectOptions` represents a custom configuration to use when connecting a Call.
 
   @discussion Connect options builder to use when connecting. For example:
 
   ```
     let connectOptions = TVOConnectOptions(accessToken: accessToken) { builder in
         builder.params = ["to": "bob"]
         builder.enableIceGatheringOnAnyAddressPorts = true
     }
 
     let call = TwilioVoiceSDK.connect(with: connectOptions, delegate: callDelegate)
   ```
 
   @see TVOCallOptions
 */
NS_SWIFT_NAME(ConnectOptions)
@interface TVOConnectOptions : TVOCallOptions

/**
 * @brief A JWT access token which will be used to connect a Call.
 */
@property (nonatomic, copy, readonly, nullable) NSString *accessToken;

/**
 * @brief The parameters passed to the server application associated with this Call.
 */
@property (nonatomic, copy, readonly, nonnull) NSDictionary <NSString *, NSString *> *params;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Use the class methods `optionsWithToken:` or `optionsWithToken:block:` instead.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("Use optionsWithToken: or optionsWithToken:block: to create a TVOConnectOptions instance.")));

/**
 *  @brief Creates `TVOConnectOptions` using an access token.
 *
 *  @discussion The maximum number of characters for the identity provided in the token is 121. The identity may
 *  only contain alpha-numeric and underscore characters. Other characters, including spaces, or exceeding the maximum
 *  number of characters, will result in not being able to place or receive calls.
 *
 *  @param accessToken A JWT access token which will be used to connect to the Call.
 *
 *  @return An instance of `TVOConnectOptions`.
 */
+ (nonnull instancetype)optionsWithAccessToken:(nonnull NSString *)accessToken;

/**
 *  @brief Creates an instance of `TVOConnectOptions` using an access token and a builder block.
 *
 *  @discussion The maximum number of characters for the identity provided in the token is 121. The identity may
 *  only contain alpha-numeric and underscore characters. Other characters, including spaces, or exceeding the maximum
 *  number of characters, will result in not being able to place or receive calls.
 *
 *  @param accessToken A JWT access token which will be used to connect to the Call.
 *  @param block The builder block which will be used to configure the `TVOConnectOptions` instance.
 *
 *  @return An instance of `TVOConnectOptions`.
 */
+ (nonnull instancetype)optionsWithAccessToken:(nonnull NSString *)accessToken
                                         block:(nonnull TVOConnectOptionsBuilderBlock)block;

@end
