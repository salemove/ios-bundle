//
//  TVOCancelledCallInvite.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The `TVOCancelledCallInvite` object represents a cancelled incoming Call Invite. `TVOCancelledCallInvite`s are not created directly;
 * they are returned by the `<[TVONotificationDelegate cancelledCallInviteReceived:error:]>` delegate method.
 */
NS_SWIFT_NAME(CancelledCallInvite)
@interface TVOCancelledCallInvite : NSObject

/**
 * @name Properties
 */

/**
 * @brief `From` value of the Call Invite.
 *
 * @discussion This may be `nil` if the notification passed in `<[TwilioVoiceSDK handleNotification:delegate:delegateQueue:]>`
 * method does not have valid information in it.
 */
@property (nonatomic, copy, readonly, nullable) NSString *from;

/**
 * @brief `To` value of the Call Invite.
 */
@property (nonatomic, copy, readonly, nonnull) NSString *to;

/**
 * @brief A server assigned identifier (SID) for the incoming Call.
 */
@property (nonatomic, copy, readonly, nonnull) NSString *callSid;

/**
   @brief Custom parameters embedded in the VoIP notification payload.

   @discussion The custom parameters will be received in the notification payload with the
   `twi_params` key and in query-string format, e.g. `key1=value1&key2=value2`. To receive custom
   parameters on the mobile client, add `<Parameter>` tags into the `<Client>` tag in the TwiML response.
 
   ```
    <?xml version="1.0" encoding="UTF-8"?>
    <Response>
      <Dial callerId="client:alice">
        <Client>
          <Identity>bob</Identity>
          <Parameter name="caller_first_name" value="alice" />
          <Parameter name="caller_last_name" value="smith" />
        </Client>
      </Dial>
    </Response>
   ```

   The `customParameters` value would be:

   ```
    {
        "caller_first_name" = "alice";
        "caller_last_name" = "smith";
    }
   ```
 
   Note: While the value field passed into `<Parameter>` gets URI encoded by the Twilio infrastructure
   and URI decoded when parsed during the creation of a `TVOCancelledCallInvite`, the name does not get URI encoded
   or decoded. As a result, it is recommended that the name field only use ASCII characters.
 */
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString *, NSString *> *customParameters;

/**
 * @brief `TVOCancelCallInvite` cannot be instantiated directly. See `<TVONotificationDelegate>` instead.
 *
 * @see TVONotificationDelegate
 */
- (null_unspecified instancetype)init __attribute__((unavailable("`TVOCancelledCallInvites` cannot be instantiated directly. See `TVONotificationDelegate`")));

@end
