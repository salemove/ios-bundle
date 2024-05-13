//
//  TwilioVoice.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TVOAcceptOptions.h"
#import "TVOAudioCodec.h"
#import "TVOAudioDevice.h"
#import "TVOAudioFormat.h"
#import "TVOBaseTrackStats.h"
#import "TVOCall.h"
#import "TVOCallDelegate.h"
#import "TVOCallerInfo.h"
#import "TVOCallInvite.h"
#import "TVOCallOptions.h"
#import "TVOCancelledCallInvite.h"
#import "TVOConnectOptions.h"
#import "TVODefaultAudioDevice.h"
#import "TVOError.h"
#import "TVOIceCandidatePairStats.h"
#import "TVOIceCandidateStats.h"
#import "TVOIceOptions.h"
#import "TVOLocalAudioTrackStats.h"
#import "TVOLocalTrackStats.h"
#import "TVONotificationDelegate.h"
#import "TVOOpusCodec.h"
#import "TVOPcmuCodec.h"
#import "TVORemoteAudioTrackStats.h"
#import "TVORemoteTrackStats.h"
#import "TVOStatsReport.h"


/**
 * An enumeration indicating log levels that can be used with the SDK.
 */
typedef NS_ENUM(NSUInteger, TVOLogLevel) {
    TVOLogLevelOff = 0,     ///< Disables all SDK logging.
    TVOLogLevelFatal,       ///< Show very severe error events that will presumably lead the application to abort.
    TVOLogLevelError,       ///< Show errors only.
    TVOLogLevelWarning,     ///< Show warnings as well as all **Error** log messages.
    TVOLogLevelInfo,        ///< Show informational messages as well as all **Warn** log messages.
    TVOLogLevelDebug,       ///< Show debugging messages as well as all **Info** log messages.
    TVOLogLevelTrace,       ///< Show low-level debugging messages as well as all **Debug** log messages.
    TVOLogLevelAll          ///< Show all logging.
}
NS_SWIFT_NAME(TwilioVoiceSDK.LogLevel);

/**
 * `TwilioVoiceSDK` logging modules.
 */
typedef NS_ENUM(NSUInteger, TVOLogModule) {
    TVOLogModuleCore = 0,   ///< Voice Core SDK.
    TVOLogModulePlatform,   ///< Voice iOS SDK.
    TVOLogModuleSignaling,  ///< Signaling module.
    TVOLogModuleWebRTC      ///< WebRTC module.
}
NS_SWIFT_NAME(TwilioVoiceSDK.LogModule);

/**
 * `TwilioVoiceSDK` is the entry point to the Twilio Voice SDK. You can register for VoIP push notifications, make outgoing
 * Calls, receive Call invites and set audio device to use in a Call using this class.
 */
@interface TwilioVoiceSDK : NSObject

/**
 * @brief The current logging level used by the SDK.
 *
 * @discussion The default logging level is `TVOLogLevelError`. `TwilioVoiceSDK` and its components use NSLog internally.
 *
 * @see TVOLogLevel
 */
@property (nonatomic, assign, class) TVOLogLevel logLevel;

/**
 * @brief Specify reporting statistics to Insights.
 *
 * @discussion Sending stats data to Insights is enabled by default.
 */
@property (nonatomic, assign, class, getter=isInsightsEnabled) BOOL insights;

/**
   @brief The edge value is a Twilio Edge name that corresponds to a geographic location of Twilio infrastructure that
   the client will connect to.

   @discussion The default value `roaming` automatically selects an edge based on the latency between client and
   available edges. `roaming` requires the upstream DNS to support [RFC7871](https://tools.ietf.org/html/rfc7871). See [Global Low Latency requirements](https://www.twilio.com/docs/voice/client/javascript/voice-client-js-and-mobile-sdks-network-connectivity-requirements#global-low-latency-requirements) for more information.
 
   `edge` value must be specified before calling TwilioVoiceSDK.handleNotification().

   See the [new Edge names](https://www.twilio.com/docs/voice/client/regions#regions) for possible values.
 */
@property (nonatomic, copy, class, nonnull) NSString *edge;

/**
 *  @brief The `TVOAudioDevice` used to record and playback audio in a Call.
 *
 *  @discussion If you wish to provide your own `TVOAudioDevice` then you must set it before performing any other
 *  actions with the SDK like connecting to a Call. It is also possible to change the device when you are no longer
 *  connected to any Calls and have destroyed all other SDK objects.
 *
 *  @see TVOAudioDevice
 */
@property (class, nonatomic, strong, nonnull) id<TVOAudioDevice> audioDevice;

/**
 * @brief Returns the version of the SDK.
 *
 * @return The version of the SDK.
 */
+ (nonnull NSString *)sdkVersion;

/**
 * @brief Sets the logging level for an individual module.
 *
 * @param logLevel The `<TVOLogLevel>` level to be used by the module.
 * @param module The `<TVOLogModule>` for which the logging level is to be set.
 *
 * @see TVOLogLevel
 * @see TVOLogModule
 */
+ (void)setLogLevel:(TVOLogLevel)logLevel module:(TVOLogModule)module;

/**
 *  @brief Retrieve the log level for a specific module in the TwilioVoice SDK.
 *
 *  @param module The `TVOLogModule` for which the log level needs to be set.
 *
 *  @return The current log level for the specified module.
 */
+ (TVOLogLevel)logLevelForModule:(TVOLogModule)module;

/**
 * @name Managing VoIP Push Notifications
 */

/**
  @brief Registers for Twilio VoIP push notifications.

  @discussion Registering for push notifications is required to receive incoming call notification messages through Twilio's
  infrastructure. Once successfully registered, the registered binding has a time-to-live(TTL) of 1 year. If the registered binding
  is inactive for 1 year it is deleted and push notifications to the registered identity will not succeed. However, whenever
  the registered binding is used to reach the registered identity the TTL is reset to 1 year. A successful registration will
  ensure that push notifications will arrive via the APNs for the lifetime of the registration device token provided by
  the APNs instance.

  Your app must initialize PKPushRegistry with PushKit push type VoIP at the launch time. As mentioned in the
  [PushKit guidelines](https://developer.apple.com/documentation/pushkit/supporting_pushkit_notifications_in_your_app),
  the system can't deliver push notifications to your app until you create a PKPushRegistry object for
  VoIP push type and set the delegate. If your app delays the initialization of PKPushRegistry, your app may receive outdated
  PushKit push notifications, and if your app decides not to report the received outdated push notifications to CallKit, iOS may
  terminate your app.

  If the registration is successful the completion handler will contain a `Null NSError`. If the registration
  fails, the completion handler will have a `nonnull NSError` with `UserInfo` string describing the reason for failure.

  <table border="1" summary="Registration Errors.">
  <tr>
  <td>Registration Error</td><td>Error Code</td><td>Description</td>
  </tr>
  <tr>
  <td> TVOErrorAccessTokenInvalidError </td><td>20101</td><td>Twilio was unable to validate your Access Token</td>
  </tr>
  <tr>
  <td> TVOErrorAccessTokenHeaderInvalidError </td><td>20102</td><td>Invalid Access Token header</td>
  </tr>
  <tr>
  <td> TVOErrorAccessTokenIssuerInvalidError </td><td>20103</td><td>Invalid Access Token issuer or subject</td>
  </tr>
  <tr>
  <td> TVOErrorAccessTokenExpiredError </td><td>20104</td><td>Access Token has expired or expiration date is invalid</td>
  </tr>
  <tr>
  <td> TVOErrorAccessTokenNotYetValidError </td><td>20105</td><td>Access Token not yet valid</td>
  </tr>
  <tr>
  <td> TVOErrorAccessTokenGrantsInvalidError </td><td>20106</td><td>Invalid Access Token grants</td>
  </tr>
  <tr>
  <td> TVOErrorExpirationTimeExceedsMaxTimeAllowedError </td><td>20157</td><td>Expiration Time in the Access Token Exceeds Maximum Time Allowed</td>
  </tr>
  <tr>
  <td> TVOErrorAccessForbiddenError </td><td>20403</td><td>Forbidden. The account lacks permission to access the Twilio API</td>
  </tr>
  <tr>
  <td> TVOErrorBadRequestError </td><td>31400</td><td>Bad Request. The request could not be understood due to malformed syntax</td>
  </tr>
  <tr>
  <td> TVOErrorForbiddenError </td><td>31403</td><td>Forbidden. The server understood the request, but is refusing to fulfill it</td>
  </tr>
  <tr>
  <td> TVOErrorNotFoundError </td><td>31404</td><td>Not Found. The server has not found anything matching the request</td>
  </tr>
  <tr>
  <td> TVOErrorRequestTimeoutError </td><td>31408</td><td>Request Timeout. A request timeout occurred</td>
  </tr>
  <tr>
  <td> TVOErrorConflictError </td><td>31409</td><td>Conflict. The request could not be processed because of a conflict in the current state of the resource. Another request may be in progress</td>
  </tr>
  <tr>
  <td> TVOErrorUpgradeRequiredError </td><td>31426</td><td>Upgrade Required. This error is raised when an HTTP 426 response is received. The reason for this is most likely because of an incompatible TLS version. To mitigate this, you may need to upgrade the OS or download a more recent version of the SDK.</td>
  </tr>
  <tr>
  <td> TVOErrorTooManyRequestsError </td><td>31429</td><td>Too Many Requests. Too many requests were sent in a given amount of time</td>
  </tr>
  <tr>
  <td> TVOErrorInternalServerError </td><td>31500</td><td>Internal Server Error. The server could not fulfill the request due to some unexpected condition</td>
  </tr>
  <tr>
  <td> TVOErrorBadGatewayError </td><td>31502</td><td>Bad Gateway. The server is acting as a gateway or proxy, and received an invalid response from a downstream server while attempting to fulfill the request</td>
  </tr>
  <tr>
  <td> TVOErrorServiceUnavailableError </td><td>31503</td><td>Service Unavailable. The server is currently unable to handle the request due to a temporary overloading or maintenance of the server</td>
  </tr>
  <tr>
  <td> TVOErrorGatewayTimeoutError </td><td>31504</td><td>Gateway Timeout. The server, while acting as a gateway or proxy, did not receive a timely response from an upstream server</td>
  </tr>
  <tr>
  <td> TVOErrorTokenAuthenticationRejected </td><td>51007</td><td>Token authentication is rejected by authentication service</td>
  </tr>
  <tr>
  <td> TVOErrorRegistrationError </td><td>31301</td><td>Registration failed. Look at [error localizedFailureReason] for details</td>
  </tr>
  </table>

  **Insights**

  <table border="1" summary="Insights events.">
  <tr>
  <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
  </tr>
  <tr>
  <td>registration</td><td>registration</td><td>Registration is successful</td><td>3.0.0-beta3</td>
  </tr>
  <tr>
  <td> registration </td> <td>registration-error</td><td>Registration failed</td><td>3.0.0-beta3</td>
  </tr>
  </table>

  ** An example of using the *registration* API **

  ```
    - (void)pushRegistry:(PKPushRegistry *)registry
    didUpdatePushCredentials:(PKPushCredentials *)credentials
             forType:(NSString *)type {
        [TwilioVoiceSDK registerWithAccessToken:accessToken
                                    deviceToken:credentials.token
                                     completion:^(NSError *error) {
            if(error != nil) {
                NSLog("Failed to register for incoming push: %@\n\t  - reason: %@", [error localizedDescription], [error localizedFailureReason]);
            } else {
                NSLog("Registration successful");
            }
        }];
  ```

  The maximum number of characters for the identity provided in the token is 121. The identity may only contain alpha-numeric
  and underscore characters. Other characters, including spaces, or exceeding the maximum number of characters, will result
  in not being able to place or receive calls.

  @param accessToken Twilio Access Token.
  @param deviceToken The push registry token raw data for Apple VoIP Service.
  @param completion Callback block to receive the result of the registration.
*/
+ (void)registerWithAccessToken:(nonnull NSString *)accessToken
                    deviceToken:(nonnull NSData *)deviceToken
                     completion:(nullable void(^)(NSError * __nullable error))completion
NS_SWIFT_NAME(register(accessToken:deviceToken:completion:));

/**
   @brief Unregisters from Twilio VoIP push notifications.
 
   @discussion Call this method when you no longer want to receive push notifications for incoming Calls.
 
   If the unregistration is successful the completion handler will contain a `Null NSError`. If the unregistration
   fails, the completion handler will have a `nonnull NSError` with `UserInfo` string describing the reason for failure.
 
   <table border="1" summary="Registration Errors.">
   <tr>
   <td>Registration Error</td><td>Error Code</td><td>Description</td>
   </tr>
   <tr>
   <td> TVOErrorAccessTokenInvalidError </td><td>20101</td><td>Twilio was unable to validate your Access Token</td>
   </tr>
   <tr>
   <td> TVOErrorAccessTokenHeaderInvalidError </td><td>20102</td><td>Invalid Access Token header</td>
   </tr>
   <tr>
   <td> TVOErrorAccessTokenIssuerInvalidError </td><td>20103</td><td>Invalid Access Token issuer or subject</td>
   </tr>
   <tr>
   <td> TVOErrorAccessTokenExpiredError </td><td>20104</td><td>Access Token has expired or expiration date is invalid</td>
   </tr>
   <tr>
   <td> TVOErrorAccessTokenNotYetValidError </td><td>20105</td><td>Access Token not yet valid</td>
   </tr>
   <tr>
   <td> TVOErrorAccessTokenGrantsInvalidError </td><td>20106</td><td>Invalid Access Token grants</td>
   </tr>
   <tr>
   <td> TVOErrorExpirationTimeExceedsMaxTimeAllowedError </td><td>20157</td><td>Expiration Time in the Access Token Exceeds Maximum Time Allowed</td>
   </tr>
   <tr>
   <td> TVOErrorAccessForbiddenError </td><td>20403</td><td>Forbidden. The account lacks permission to access the Twilio API</td>
   </tr>
   <tr>
   <td> TVOErrorBadRequestError </td><td>31400</td><td>Bad Request. The request could not be understood due to malformed syntax</td>
   </tr>
   <tr>
   <td> TVOErrorForbiddenError </td><td>31403</td><td>Forbidden. The server understood the request, but is refusing to fulfill it</td>
   </tr>
   <tr>
   <td> TVOErrorNotFoundError </td><td>31404</td><td>Not Found. The server has not found anything matching the request</td>
   </tr>
   <tr>
   <td> TVOErrorRequestTimeoutError </td><td>31408</td><td>Request Timeout. A request timeout occurred</td>
   </tr>
   <tr>
   <td> TVOErrorConflictError </td><td>31409</td><td>Conflict. The request could not be processed because of a conflict in the current state of the resource. Another request may be in progress</td>
   </tr>
   <tr>
   <td> TVOErrorUpgradeRequiredError </td><td>31426</td><td>Upgrade Required. This error is raised when an HTTP 426 response is received. The reason for this is most likely because of an incompatible TLS version. To mitigate this, you may need to upgrade the OS or download a more recent version of the SDK</td>
   </tr>
   <tr>
   <td> TVOErrorTooManyRequestsError </td><td>31429</td><td>Too Many Requests. Too many requests were sent in a given amount of time</td>
   </tr>
   <tr>
   <td> TVOErrorInternalServerError </td><td>31500</td><td>Internal Server Error. The server could not fulfill the request due to some unexpected condition</td>
   </tr>
   <tr>
   <td> TVOErrorBadGatewayError </td><td>31502</td><td>Bad Gateway. The server is acting as a gateway or proxy, and received an invalid response from a downstream server while attempting to fulfill the request</td>
   </tr>
   <tr>
   <td> TVOErrorServiceUnavailableError </td><td>31503</td><td>Service Unavailable. The server is currently unable to handle the request due to a temporary overloading or maintenance of the server</td>
   </tr>
   <tr>
   <td> TVOErrorGatewayTimeoutError </td><td>31504</td><td>Gateway Timeout. The server, while acting as a gateway or proxy, did not receive a timely response from an upstream server</td>
   </tr>
   <tr>
   <td> TVOErrorTokenAuthenticationRejected </td><td>51007</td><td>Token authentication is rejected by authentication service</td>
   </tr>
   <tr>
   <td> TVOErrorRegistrationError </td><td>31301</td><td>Registration failed. Look at [error localizedFailureReason] for details</td>
   </tr>
   </table>
 
   **Insights**
 
   <table border="1" summary="Insights events.">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>registration</td><td>unregistration</td><td>Unregistration is successful</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>registration</td><td>unregistration-error</td><td>Unregistration failed</td><td>3.0.0-beta3</td>
   </tr>
   </table>
 
   ** An example of using the *unregistration* API **
 
   ```
     [TwilioVoiceSDK unregisterWithAccessToken:accessToken
                                   deviceToken:deviceToken
                                    completion:^(NSError *error) {
         if(error != nil) {
             NSLog("Failed to unregister for incoming push: %@\n\t  - reason: %@", [error localizedDescription], [error localizedFailureReason]);
         } else {
             NSLog("Unregistration successful");
         }
     }];
   ```
 
   The maximum number of characters for the identity provided in the token is 121. The identity may only contain alpha-numeric
   and underscore characters. Other characters, including spaces, or exceeding the maximum number of characters, will result
   in not being able to place or receive calls.
 
   @param accessToken Twilio Access Token.
   @param deviceToken The push registry token raw data for Apple VoIP Service.
   @param completion Callback block to receive the result of the unregistration.
 */
+ (void)unregisterWithAccessToken:(nonnull NSString *)accessToken
                      deviceToken:(nonnull NSData *)deviceToken
                       completion:(nullable void(^)(NSError * __nullable error))completion
NS_SWIFT_NAME(unregister(accessToken:deviceToken:completion:));

/**
   @brief Processes an incoming VoIP push notification payload.
 
   @discussion This method will synchronously process call notification payload and call the provided delegate
   on the same dispatch queue.
 
   @discussion If you are specifying an edge value via the `TwilioVoiceSDK.edge` property you must do so before calling this method.
 
   Twilio sends a `call` notification via Apple VoIP Service.
   The notification type is encoded in the dictionary with the key `twi_message_type` and the value
   `twilio.voice.call`.
 
   A `call` notification is sent when someone wants to reach the registered `identity`.
   Passing a `call` notification into this method will result in a `callInviteReceived:` callback with a `<TVOCallInvite>`
   object and return `YES`.

   To ensure that a cancellation is reported via the [TVONotificationDelegate cancelledCallInviteReceived:error:] callback,
   the TVOCallInvite must be retained until the call is accepted or rejected.
 
   **Insights**
 
   <table border="1" summary="Insights events.">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <tr>
   <td>connection</td><td>incoming</td><td>Incoming call notification received</td><td>3.0.0-preview1</td>
   </tr>
   <tr>
   <td>connection</td><td>listen</td><td>Reported when an attempt to listen for cancellations is made</td><td>5.0.0</td>
   </tr>
   <tr>
   <td>connection</td><td>listening</td><td>Reported when an attempt to listen for cancellations has succeeded</td><td>5.0.0</td>
   </tr>
   <tr>
   <td>connection</td><td>cancel</td><td>Reported when a cancellation has been reported</td><td>5.0.0</td>
   </tr>
   <tr>
   <td>connection</td><td>listening-error</td><td>Reported when an attempt to listen for a cancellation has failed</td><td>5.0.0</td>
   </tr>
   <tr>
   <td>registration</td><td>unsupported-cancel-message-error</td><td>Reported when a "cancel" push notification is processed by the SDK. This version of the SDK does not support "cancel" push notifications</td><td>5.0.0</td>
   </tr>
   </table>
 
   ** An example of using the *handleNotification* API **
 
   ```
    @interface CallViewController () <PKPushRegistryDelegate, TVONotificationDelegate, TVOCallDelegate, ... >
 
    // property declarations
 
    @end
 
    @implementation CallViewController
 
    // ViewController setup and other code ...
 
    #pragma mark - PKPushRegistryDelegate
 
    - (void)pushRegistry:(PKPushRegistry *)registry
        didReceiveIncomingPushWithPayload:(PKPushPayload *)payload
        forType:(NSString *)type {
            NSLog(@"Received incoming push: %@", payload.dictionaryPayload);
 
            if ([type isEqualToString:PKPushTypeVoIP]) {
                if (![TwilioVoiceSDK handleNotification:payload.dictionaryPayload delegate:self]) {
                    NSLog(@"The push notification was not a Twilio Voice push notification");
            }
        }
    }
 
    #pragma mark - TVONotificationDelegate methods
 
    - (void)callInviteReceived:(TVOCallInvite *)callInvite {
        // handle call invite
    }
 
    - (void)cancelledCallInviteReceived:(TVOCancelledCallInvite *)cancelledCallInvite {
        // handle cancelled call invite
    }
 
    @end
   ```
   @param payload Push notification payload.
   @param delegate A `<TVONotificationDelegate>` to receive incoming push notification callbacks.
   @param delegateQueue The queue where the `[TVONotificationDelegate cancelledCallInviteReceived:error:]` method will invoked. By default the main dispatch queue will be used.
 
   @return A BOOL value that indicates whether the payload is a valid notification sent by Twilio.
 
   @see TVONotificationDelegate
 */
+ (BOOL)handleNotification:(nonnull NSDictionary *)payload
                  delegate:(nonnull id<TVONotificationDelegate>)delegate
             delegateQueue:(nullable dispatch_queue_t)delegateQueue;

/**
 * @name Connecting Calls
 */

/**
   @brief Make an outgoing Call.
 
   @discussion This method is guaranteed to return a `<TVOCall>` object. It's possible for the returned Call to either
   succeed or fail to connect.
 
   If you are specifying an edge value via the `TwilioVoiceSDK.edge` property you must do so before calling this method.
 
   The `<TVOCallDelegate>` will receive the Call state update callbacks. The callbacks are listed here.
 
   <table border="1" summary="TVOCallDelegate events.">
   <tr>
   <td>Callback Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td> call:didFailToConnectWithError </td><td>The call failed to connect. An `NSError` object provides details of the root cause.</td><td>3.0.0-preview1</td>
   </tr>
   <tr>
   <td> callDidStartRinging </td><td>Emitted once before the `callDidConnect` callback when the callee is being alerted of a Call.</td><td>3.0.0-preview2</td>
   </tr>
   <tr>
   <td> callDidConnect </td><td>The Call has connected.</td><td>3.0.0-preview1</td>
   </tr>
   <tr>
   <td> call:didDisconnectWithError </td><td>The Call was disconnected. If the Call ends due to an error the `NSError` is non-null. If the call ends normally `NSError` is nil.</td><td>3.0.0-preview1</td>
   </tr>
   </table>
 
   If connect fails, `call:didFailToConnectWithError` or `call:didDisconnectWithError` callback is raised with an `NSError` object. `[error localizedDescription]`,
   `[error localizedFailureReason]` and `[error code]` provide details of the failure.
 
   If any authentication error occurs then the SDK will receive one of the following errors.
 
   <table border="1" summary="Call Connect errors">
   <tr>
   <td>Authentication Errors</td><td>Error Code</td><td>Description</td>
   </tr>
   <tr>
   <td>TVOErrorAccessTokenInvalidError</td><td>20101</td><td>Twilio was unable to validate your Access Token</td>
   </tr>
   <tr>
   <td>TVOErrorAccessTokenHeaderInvalidError</td><td>20102</td><td>Invalid Access Token header</td>
   </tr>
   <tr>
   <td>TVOErrorAccessTokenIssuerInvalidError</td><td>20103</td><td>Invalid Access Token issuer or subject</td>
   </tr>
   <tr>
   <td>TVOErrorAccessTokenExpiredError</td><td>20104</td><td>Access Token has expired or expiration date is invalid</td>
   </tr>
   <tr>
   <td>TVOErrorAccessTokenNotYetValidError</td><td>20105</td><td>Access Token not yet valid</td>
   </tr>
   <tr>
   <td>TVOErrorAccessTokenGrantsInvalidError</td><td>20106</td><td>Invalid Access Token grants</td>
   </tr>
   <tr>
   <td>TVOErrorAuthFailureCodeError</td><td>20151</td><td>Twilio failed to authenticate the client</td>
   </tr>
   <tr>
   <td>TVOErrorExpirationTimeExceedsMaxTimeAllowedError</td><td>20157</td><td>Expiration Time in the Access Token Exceeds Maximum Time Allowed</td>
   </tr>
   <tr>
   <td>TVOErrorAccessForbiddenError</td><td>20403</td><td>Forbidden. The account lacks permission to access the Twilio API</td>
   </tr>
   <tr>
   <td>TVOErrorApplicationNotFoundError</td><td>21218</td><td>Invalid ApplicationSid</td>
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
   <td>TVOErrorMalformedRequestError</td><td>31100</td><td>Malformed request</td>
   </tr>
   <tr>
   <td>TVOErrorAuthorizationError</td><td>31201</td><td>Authorization error</td>
   </tr>
   <tr>
   <td>TVOErrorBadRequestError</td><td>31400</td><td>Bad Request</td>
   </tr>
   <tr>
   <td>TVOErrorForbiddenError</td><td>31403</td><td>Forbidden</td>
   </tr>
   <tr>
   <td>TVOErrorNotFoundError</td><td>31404</td><td>Not Found</td>
   </tr>
   <tr>
   <td>TVOErrorRequestTimeoutError</td><td>31408</td><td>Request Timeout</td>
   </tr>
   <tr>
   <td>TVOErrorTemporarilyUnavailableError</td><td>31480</td><td>Temporarily Unavailable</td>
   </tr>
   <tr>
   <td>TVOErrorCallDoesNotExistError</td><td>31481</td><td>Call/Transaction Does Not Exist</td>
   </tr>
   <tr>
   <td>TVOErrorAddressIncompleteError</td><td>31484</td><td>The phone number is malformed</td>
   </tr>
   <tr>
   <td>TVOErrorBusyHereError</td><td>31486</td><td>Busy Here</td>
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
   <td>TVOErrorDeclineError</td><td>31603</td><td>Decline</td>
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
   <td>connection</td><td>outgoing</td><td>Outgoing call is made</td><td>3.0.0-beta2</td>
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
 
   ** An example of using the *connectWithAccessToken:delegate:* API **
 
   ```
    @interface CallViewController () <TVOCallDelegate, ... >
 
    // property declarations
 
    @end
 
    @implementation CallViewController
 
    // ViewController setup and other code ...
 
    - (void)makeCall:(NSString*)accessToken
        self.call = [TwilioVoiceSDK connectWithAccessToken:accessToken delegate:self];
    }
 
    #pragma mark - TVOCallDelegate
 
    - (void)callDidStartRinging:(TVOCall *)call {
        NSLog(@"Call is ringing at called party %@", call.to);
    }
 
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
 
   The maximum number of characters for the identity provided in the token is 121. The identity may only contain alpha-numeric
   and underscore characters. Other characters, including spaces, or exceeding the maximum number of characters, will result
   in not being able to place or receive calls.
 
   @param accessToken The access token.
   @param delegate A `<TVOCallDelegate>` to receive Call state updates.
 
   @return A `<TVOCall>` object.
 
   @see TVOCall
   @see TVOCallDelegate
 */
+ (nonnull TVOCall *)connectWithAccessToken:(nonnull NSString *)accessToken
                                   delegate:(nonnull id<TVOCallDelegate>)delegate
NS_SWIFT_NAME(connect(accessToken:delegate:));

/**
   @brief Make an outgoing Call.
 
   @discussion This method is guaranteed to return a `<TVOCall>` object. It's possible for the returned Call to either
   succeed or fail to connect. Use the `<TVOConnectOptions>` builder to specify Call parameters and UUID.
 
   @discussion If you are specifying an edge value via the `TwilioVoiceSDK.edge` property you must do so before calling this method.
 
   The `<TVOCallDelegate>` will receive the Call state update callbacks. The callbacks are same as `connectWithAccessToken:delegate:` API.
 
   If connect fails, `call:didFailToConnectWithError` or `call:didDisconnectWithError` callback is raised with an `NSError` object. `[error localizedDescription]`,
   `[error localizedFailureReason]` and `[error code]` provide details of the failure. The error codes are same as `connectWithAccessToken:delegate:` API.
 
   **Insights**
 
   <table border="1" summary="Insights events.">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>connection</td><td>outgoing</td><td>Outgoing call is made</td><td>3.0.0-beta2</td>
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
 
   ** An example of using the *connectWithAccessToken:delegate* API **

 
   ```
    @interface CallViewController () <TVOCallDelegate, ... >
 
    // property declarations
 
    @end
 
    @implementation CallViewController
 
    // ViewController setup and other code ...
 
    - (void)makeCall:(NSString *)accessToken uuid:(NSString *)uuid to:(NSString *)phoneNumber
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
 
        if ([to length] > 0) {
            params[@"Mode"] = @"Voice";
            params[@"PhoneNumber"] = phoneNumber;
        }
 
        TVOConnectOptions *connectOptions = [TVOConnectOptions optionsWithAccessToken:accessToken
            block:^(TVOConnectOptionsBuilder *builder) {
                builder.params = params;
                builder.uuid = uuid;
        }];
 
        self.call = [TwilioVoiceSDK connectWithOptions:connectOptions delegate:self];
    }
 
    #pragma mark - TVOCallDelegate
 
    - (void)callDidStartRinging:(TVOCall *)call {
        NSLog(@"Call is ringing at called party %@", call.to);
    }
 
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
 
   @param options The connect options.
   @param delegate A `<TVOCallDelegate>` to receive Call state updates.
 
   @return A `<TVOCall>` object.
 
   @see TVOCall
   @see TVOCallDelegate
   @see TVOConnectOptions
 */
+ (nonnull TVOCall *)connectWithOptions:(nonnull TVOConnectOptions *)options
                               delegate:(nonnull id<TVOCallDelegate>)delegate
NS_SWIFT_NAME(connect(options:delegate:));

- (null_unspecified instancetype)init __attribute__((unavailable("TwilioVoiceSDK cannot be instantiated directly.")));

@end


/**
 * CallKit Audio Session Handling
 */
@interface TwilioVoiceSDK (CallKitIntegration)

@end
