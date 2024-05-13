//
//  TVOCallerInfo.h
//  TwilioVoice
//
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

/**
   @brief A `TVOCallerInfo` is used to represent the SHAKEN/STIR status information about the caller.
   `TVOCallerInfo` is not created directly; use the `TVOCallInvite.callerInfo` property instead.
 */
@interface TVOCallerInfo : NSObject

/**
   @brief Returns `true` in `NSNumber` if the caller has been validated at 'A' level, `false` if the caller has been
   verified at any lower level or has failed validation. Returns `nil` if no caller verification information is available or
   if stir status value is `null`.
 */
@property (nonatomic, strong, readonly, nullable, getter=isVerified) NSNumber *verified;

/**
 * @brief Caller Info objects cannot be instantiated directly. Use the `TVOCallInvite.callerInfo` property instead.
 *
 * @see TVOCallInvite;
 */
- (null_unspecified instancetype)init __attribute__((unavailable("Caller Info objects cannot be instantiated directly. See `TVOCallInvite.callerInfo`")));

@end
