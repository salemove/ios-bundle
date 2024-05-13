//
//  TVONotificationDelegate.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TVOCallInvite;
@class TVOCancelledCallInvite;

/**
 * Objects can conform to the `TVONotificationDelegate` protocol to be informed when incoming Call Invites are
 * received or cancelled.
 */
NS_SWIFT_NAME(NotificationDelegate)
@protocol TVONotificationDelegate <NSObject>

/**
 * @name Required Methods
 */

/**
 * @brief Notifies the delegate that a Call Invite was received.
 *
 * @discussion This method gets invoked synchronously on the same dispatch queue where the `[TwilioVoiceSDK handleNotification:delegate:delegateQueue:]`
 * is called.
 *
 * @param callInvite A `<TVOCallInvite>` object.
 *
 * @see TVOCallInvite
 */
- (void)callInviteReceived:(nonnull TVOCallInvite *)callInvite
NS_SWIFT_NAME(callInviteReceived(callInvite:));

/**
 * @brief Notifies the delegate that a Cancelled Call Invite was received.
 *
 * @discussion A Cancelled Call Invite has the terminal state and can not perform further actions.
 * This method gets invoked synchronously on the same dispatch queue where the `[TwilioVoiceSDK handleNotification:delegate:delegateQueue:]`
 * is called.
 *
 * @param cancelledCallInvite A `<TVOCancelledCallInvite>` object.
 * @param error The `<NSError>` that occurred.
 *
 * @see TVOCancelledCallInvite
 */
- (void)cancelledCallInviteReceived:(nonnull TVOCancelledCallInvite *)cancelledCallInvite error:(nonnull NSError *)error
NS_SWIFT_NAME(cancelledCallInviteReceived(cancelledCallInvite:error:));

@end
