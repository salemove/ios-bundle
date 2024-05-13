//
//  TVOCallInvite.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

@class TVOAcceptOptions;
@class TVOCall;
@class TVOCallerInfo;
@protocol TVOCallDelegate;

/**
 * The `TVOCallInvite` object represents an incoming Call Invite. `TVOCallInvite`s are not created directly;
 * they are returned by the `<[TVONotificationDelegate callInviteReceived:]>` delegate method.
 */
NS_SWIFT_NAME(CallInvite)
@interface TVOCallInvite : NSObject

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
 *
 * @discussion Accepting a `TVOCallInvite` yields a `TVOCall` which inherits this SID.
 *
 * @see TVOCall.sid
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
   and URI decoded when parsed during the creation of a `TVOCallInvite`, the name does not get URI encoded
   or decoded. As a result, it is recommended that the name field only use ASCII characters.
 */
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString *, NSString *> *customParameters;

/**
   @brief The `TVOCallerInfo` that represents SHAKEN/STIR status information about the caller.
 
   @see TVOCallerInfo.
 */
@property (nonatomic, strong, readonly, nonnull) TVOCallerInfo *callerInfo;

/**
 * @name Call Invite Actions
 */

/**
   @brief Accepts the incoming Call Invite.
 
   @discussion This method is guaranteed to return a `<TVOCall>` object. It's possible for the returned Call to either succeed or fail to connect.
 
   The `<TVOCallDelegate>` will receive the Call state update callbacks. The callbacks are listed here.
 
   <table border="1" summary="TVOCallDelegate events.">
   <tr>
   <td>Callback Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td> call:didFailToConnectWithError </td><td>The call failed to connect. An `NSError` object provides details of the root cause.</td><td>3.0.0-preview1</td>
   </tr>
   <tr>
   <td> callDidStartRinging: </td><td>This callback should not be invoked when calling `<[TVOCallInvite acceptWithDelegate:]>`.</td><td>3.0.0-preview2</td>
   </tr>
   <tr>
   <td> callDidConnect: </td><td>The Call has connected.</td><td>3.0.0-preview1</td>
   </tr>
   <tr>
   <td> call:didDisconnectWithError </td><td>The Call was disconnected. If the Call ends due to an error the `NSError` is non-null. If the call ends normally `NSError` is nil.</td><td>3.0.0-preview1</td>
   </tr>
   </table>
 
   If accept fails, `call:didFailToConnectWithError:` or `call:didDisconnectWithError:` callback is raised with an `NSError` object. `[error localizedDescription]`,
   `[error localizedFailureReason]` and `[error code]` provide details of the failure.
 
   If `<[TVOCallInvite acceptWithDelegate:]>` fails due to an authentication error, the SDK receives the following error.
 
   <table border="1" summary="Authentication Errors">
   <tr>
   <td>Authentication Errors</td><td>Error Code</td><td>Description</td>
   </tr>
   <tr>
   <td>TVOErrorAuthFailureCodeError</td><td>20151</td><td>Twilio failed to authenticate the client</td>
   </tr>
   </table>
 
   If any connection fails because of any other error then the SDK will receive one of the following errors.
 
   <table border="1" summary="Call Connect errors">
   <tr>
   <td>Connection Errors</td><td>Error Code</td><td>Description</td>
   </tr>
   <tr>
   <td>TVOErrorConnectionError</td><td>31005</td><td>Connection error</td>
   </tr>
   <tr>
   <td>TVOErrorCallCancelledError</td><td>31008</td><td>Call Cancelled</td>
   </tr>
   <tr>
   <td>TVOErrorTransportError</td><td>31009</td><td>Transport error</td>
   </tr>
   <tr>
   <td>TVOErrorAuthorizationError</td><td>31201</td><td>Authorization error</td>
   </tr>
   <tr>
   <td>TVOErrorForbiddenError</td><td>31403</td><td>Forbidden</td>
   </tr>
   <tr>
   <td>TVOErrorRequestTimeoutError</td><td>31408</td><td>Request Timeout</td>
   </tr>
   <tr>
   <td>TVOErrorCallDoesNotExistError</td><td>31481</td><td>Call/Transaction Does Not Exist</td>
   </tr>
   <tr>
   <td>TVOErrorRequestTerminatedError</td><td>31487</td><td>Request Terminated</td>
   </tr>
   <tr>
   <td>TVOErrorInternalServerError</td><td>31500</td><td>Internal Server Error</td>
   </tr>
   <tr>
   <td>TVOErrorBadGatewayError</td><td>31502</td><td>Bad Gateway</td>
   </tr>
   <tr>
   <td>TVOErrorServiceUnavailableError</td><td>31503</td><td>Service Unavailable</td>
   </tr>
   <tr>
   <td>TVOErrorGatewayTimeoutError</td><td>31504</td><td>Gateway Timeout</td>
   </tr>
   <tr>
   <td>TVOErrorDNSResolutionError</td><td>31530</td><td>DNS Resolution Error</td>
   </tr>
   <tr>
   <td>TVOErrorDoesNotExistAnywhereError</td><td>31604</td><td>Does Not Exist Anywhere</td>
   </tr>
   <tr>
   <td>TVOErrorSignalingConnectionDisconnectedError</td><td>53001</td><td>Signaling connection disconnected</td>
   </tr>
   <tr>
   <td>TVOErrorMediaClientLocalDescFailedError</td><td>53400</td><td>Client is unable to create or apply a local media description</td>
   </tr>
   <tr>
   <td>TVOErrorMediaServerLocalDescFailedError</td><td>53401</td><td>Server is unable to create or apply a local media description</td>
   </tr>
   <tr>
   <td>TVOErrorMediaClientRemoteDescFailedError</td><td>53402</td><td>Client is unable to apply a remote media description</td>
   </tr>
   <tr>
   <td>TVOErrorMediaServerRemoteDescFailedError</td><td>53403</td><td>Server is unable to apply a remote media description</td>
   </tr>
   <tr>
   <td>TVOErrorMediaNoSupportedCodecError</td><td>53404</td><td>No supported codec</td>
   </tr>
   <tr>
   <td>TVOErrorMediaConnectionError</td><td>53405</td><td>Media connection failed</td>
   </tr>
   <tr>
   <td>TVOMediaDtlsTransportFailedErrorCode</td><td>53407</td><td>Media connection failed due to DTLS handshake failure</td>
   </tr>
   </table>
 
   **Insights**
 
   <table border="1" summary="Insights events.">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>connection</td><td>accepted-by-local</td><td>Call invite accepted</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>settings</td><td>codec</td><td>negotiated selected codec is received and remote SDP is set</td><td>5.1.1</td>
   </tr>
   </table>
 
   If connection fails then an error event will be published.

   <table border="1" summary="Insights events.">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>connection</td><td>error</td><td>error description</td><td>3.0.0-beta2</td>
   </tr>
   </table>
 
   ** An example of using the *acceptWithDelegate:* API **

   ```
    @interface CallViewController () <TVOCallDelegate, TVONotificationDelegate, ... >

    // property declarations

    @end

    @implementation CallViewController

    // ViewController setup and other code ...
 
    - (void)callInviteReceived:(TVOCallInvite *)callInvite {
        self.call = [callInvite acceptWithDelegate:self];
    }
 
    #pragma mark - TVOCallDelegate
 
    - (void)call:(TVOCall *)call didFailToConnectWithError:(NSError *)error {
        NSLog("Failed to Connect the Call: %@\n\t  - reason: %@", [error localizedDescription], [error localizedFailureReason]);
    }
 
    - (void)call:(TVOCall *)call didDisconnectWithError:(NSError *)error {
        if (error) {
            NSLog(@"Call disconnected with error: %@", error);
        } else {
            NSLog(@"Call disconnected");
        }
    }
 
    - (void)callDidConnect:(TVOCall *)call {
        NSLog(@"Call connected.");
    }
 
    @end
   ```

   @param delegate A `<TVOCallDelegate>` to receive Call state updates.
   @return A `TVOCall` object.

   @see TVOCallDelegate
 */
- (nonnull TVOCall *)acceptWithDelegate:(nonnull id<TVOCallDelegate>)delegate;

/**
   @brief Accepts the incoming Call Invite.
 
   @discussion This method is guaranteed to return a `<TVOCall>` object. It's possible for the returned Call to either succeed or fail to connect.
 
   The `<TVOCallDelegate>` will receive the Call state update callbacks. The callbacks are same as `acceptWithDelegate:` API.
 
   If accept fails, `call:didFailToConnectWithError:` or `call:didDisconnectWithError:` callback is raised with an `NSError` object. `[error localizedDescription]`, `[error localizedFailureReason]` and `[error code]` provide details of the failure. The error codes are same as `acceptWithDelegate:` API.
 
   **Insights**
 
   <table border="1" summary="Insights events.">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>connection</td><td>accepted-by-local</td><td>Call invite accepted</td><td>3.0.0-beta2</td>
   </tr>
   </table>
 
   If connection fails then an error event will be published.
 
   <table border="1" summary="Insights events.">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>connection</td><td>error</td><td>error description</td><td>3.0.0-beta2</td>
   </tr>
   </table>
 
   ** An example of using the *acceptWithOptions:delegate:* API **
 
   ```
    @interface CallViewController () <TVOCallDelegate, TVONotificationDelegate, ... >
 
    // property declarations
 
    @end
 
    @implementation CallViewController
 
    // ViewController setup and other code ...
 
    - (void)callInviteReceived:(TVOCallInvite *)callInvite {
        TVOAcceptOptions *options = [TVOAcceptOptions optionsWithCallInvite:callInvite
                                                                      block:^(TVOAcceptOptionsBuilder *builder) {
            builder.uuid = callInvite.uuid;
        }];
        self.call = [callInvite acceptWithOptions:options delegate:self];
    }
 
    #pragma mark - TVOCallDelegate
 
    - (void)call:(TVOCall *)call didFailToConnectWithError:(NSError *)error {
        NSLog("Failed to Connect the Call: %@\n\t  - reason: %@", [error localizedDescription], [error localizedFailureReason]);
    }
 
    - (void)call:(TVOCall *)call didDisconnectWithError:(NSError *)error {
        if (error) {
            NSLog(@"Call disconnected with error: %@", error);
        } else {
            NSLog(@"Call disconnected");
        }
    }
 
    - (void)callDidConnect:(TVOCall *)call {
        NSLog(@"Call connected.");
    }
 
    @end
   ```

   @param options An accept options.
   @param delegate A `<TVOCallDelegate>` to receive Call state updates.

   @return A `TVOCall` object.

   @see TVOAcceptOptions
   @see TVOCallDelegate
 */
- (nonnull TVOCall *)acceptWithOptions:(nonnull TVOAcceptOptions *)options delegate:(nonnull id<TVOCallDelegate>)delegate
NS_SWIFT_NAME(accept(options:delegate:));

/**
   @brief Rejects the incoming Call Invite.
 
   **Insights**
 
   <table border="1" summary="Insights events.">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>connection</td><td>rejected-by-local</td><td>Call invite rejected</td><td>3.0.0-preview5</td>
   </tr>
   <tr>
   <td>connection</td><td>error</td><td>The event will be sent with code 31600 and message "Busy Everywhere : SIP/2.0 600 Call Rejected"</td><td>3.1.0</td>
   </tr>
   </table>
 */
- (void)reject;

/**
 * @brief Call Invites cannot be instantiated directly. See `<TVONotificationDelegate>` instead.
 *
 * @see TVONotificationDelegate
 */
- (null_unspecified instancetype)init __attribute__((unavailable("Call Invites cannot be instantiated directly. See `TVONotificationDelegate`")));

@end


/**
 *  CallKit specific additions.
 */
@interface TVOCallInvite (CallKit)

/**
 * @brief UUID of the Call Invite.
 *
 * @discussion Use this UUID for CallKit methods. Accepting a `TVOCallInvite` yields a `TVOCall` which inherits its
 * UUID from the Invite.
 */
@property (nonatomic, copy, readonly, nonnull) NSUUID *uuid;

@end

/**
 * Utility methods.
 */
@interface TVOCallInvite (Utility)

/**
 * @brief Returns `true` if the provided payload would result in a `TVOCallInvite` via the `[TVONotificationDelegate callInviteReceived:]`
 * callback when passed into `[TwilioVoiceSDK handleNotification:delegate:delegateQueue:]`.
 *
 * @param payload Push notification payload.
 */
+ (BOOL)isValid:(nonnull NSDictionary *)payload;

@end
