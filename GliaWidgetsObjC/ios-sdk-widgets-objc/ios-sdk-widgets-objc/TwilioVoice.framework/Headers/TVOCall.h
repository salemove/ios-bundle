//
//  TVOCall.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

@protocol TVOCallDelegate;
@class TVOStatsReport;

/**
 * Enumeration indicating the state of the Call.
 */
typedef NS_ENUM(NSUInteger, TVOCallState) {
    TVOCallStateConnecting = 0, ///< The Call is connecting.
    TVOCallStateRinging,        ///< The Call is ringing.
    TVOCallStateConnected,      ///< The Call is connected.
    TVOCallStateReconnecting,   ///< The Call is reconnecting.
    TVOCallStateDisconnected    ///< The Call is disconnected.
}
NS_SWIFT_NAME(Call.State);

/**
 * Available scores for Call quality feedback.
 */
typedef NS_ENUM(NSUInteger, TVOCallFeedbackScore) {
    TVOCallFeedbackScoreNotReported = 0, ///< No score reported.
    TVOCallFeedbackScoreOnePoint,        ///< Terrible call quality, call dropped, or caused great difficulty in communicating.
    TVOCallFeedbackScoreTwoPoints,       ///< Bad call quality, like choppy audio, periodic one-way-audio.
    TVOCallFeedbackScoreThreePoints,     ///< Average call quality, manageable with some noise/minor packet loss.
    TVOCallFeedbackScoreFourPoints,      ///< Good call quality, minor issues.
    TVOCallFeedbackScoreFivePoints       ///< Great call quality. No issues.
}
NS_SWIFT_NAME(Call.FeedbackScore);

/**
 * Available issues for Call quality feedback.
 */
typedef NS_ENUM(NSUInteger, TVOCallFeedbackIssue) {
    TVOCallFeedbackIssueNotReported = 0, ///< No issue reported.
    TVOCallFeedbackIssueDroppedCall,     ///< Call initially connected but was dropped.
    TVOCallFeedbackIssueAudioLatency,    ///< Participants can hear each other but with significant delay.
    TVOCallFeedbackIssueOneWayAudio,     ///< One participant couldn’t hear the other.
    TVOCallFeedbackIssueChoppyAudio,     ///< Periodically, participants couldn’t hear each other. Some words were lost.
    TVOCallFeedbackIssueNoisyCall,       ///< There was disturbance, background noise, low clarity.
    TVOCallFeedbackIssueEcho             ///< There was echo during Call.
}
NS_SWIFT_NAME(Call.FeedbackIssue);

/**
 * Call quality warning types.
 */
typedef NS_ENUM(NSUInteger, TVOCallQualityWarning) {
    TVOCallQualityWarningHighRtt = 0,             ///< High Round Trip Time warning.
    TVOCallQualityWarningHighJitter,              ///< High Jitter warning.
    TVOCallQualityWarningHighPacketsLostFraction, ///< High Packets lost fraction warning.
    TVOCallQualityWarningLowMos,                  ///< Low Mean Opinion Score warning.
    TVOCallQualityWarningConstantAudioInputLevel  ///< Constant audio level warning.
}
NS_SWIFT_NAME(Call.QualityWarning);

/**
 * `TVOCallGetStatsBlock` is invoked asynchronously when the results of the `<[TVOCall getStatsWithBlock:]>` method are available.
 *
 * @param statsReports A collection of `TVOStatsReport` objects
 */
typedef void (^TVOCallGetStatsBlock)(NSArray<TVOStatsReport *> * _Nonnull statsReports)
NS_SWIFT_NAME(Call.GetStatsBlock);

/**
   The `TVOCall` class represents a signaling and media session between the host device and Twilio infrastructure.
   Calls can represent an outbound call initiated from the SDK via `<[TwilioVoiceSDK connectWithAccessToken:delegate:]>`
   or an incoming call accepted via a `<[TVOCallInvite acceptWithDelegate:]>`. Devices that initiate an outbound
   call represent the caller and devices that receive a `<TVOCallInvite>` represent the callee.
 
   The lifecycle of a call differs for the caller and the callee. Making or accepting a call requires a `<TVOCallDelegate>`
   which receives call state changes defined in `<TVOCallState>`. The `<TVOCallState>` can be obtained at any time from
   the `state` property of `TVOCall`.
 
   The caller callback behavior is affected by the `answerOnBridge` flag provided in the `Dial` verb of your TwiML application
   associated with this client. If the `answerOnBridge` flag is `false`, which is the default, the `<[TVOCallDelegate callDidConnect:]>`
   callback will be emitted immediately after `<[TVOCallDelegate callDidStartRinging:]>`. If the `answerOnBridge` flag
   is `true` this will cause the call to emit the `<[TVOCallDelegate callDidConnect:]>` callback only until the call
   is answered.
   See <a href="https://www.twilio.com/docs/voice/twiml/dial#answeronbridge">Answer on Bridge documentation</a> for
   more details on how to use it with the `Dial` TwiML verb.

   The following table provides expected call sequences for common scenarios from the perspective of the caller:

   <table border="1" summary="Caller Scenarios">
   <tr>
    <td>Scenario</td><td>`<TVOCallDelegate>` Callbacks</td><td>`<TVOCallState>` Transitions</td>
   </tr>
   <tr>
    <td>A call is initiated and the caller disconnects before reaching the ringing state.</td>
    <td>
      <ol>
        <li>`<[TVOCallDelegate call:didDisconnectWithError:]>`</li>
      </ol>
    </td>
    <td>
      <ol>
        <li>`TVOCallStateConnecting`</li>
        <li>`TVOCallStateDisconnected`</li>
      </ol>
    </td>
   </tr>
   <tr>
    <td>A call is initiated, reaches the ringing state and the caller disconnects before being connected.</td>
    <td>
      <ol>
        <li>`<[TVOCallDelegate callDidStartRinging:]>`</li>
        <li>`<[TVOCallDelegate call:didDisconnectWithError:]>`</li>
      </ol>
    </td>
    <td>
      <ol>
        <li>`TVOCallStateConnecting`</li>
        <li>`TVOCallStateRinging`</li>
        <li>`TVOCallStateDisconnected`</li>
      </ol>
    </td>
   </tr>
   <tr>
    <td>A call is initiated and the call fails to connect before reaching the ringing state.</td>
    <td>
      <ol>
        <li>`<[TVOCallDelegate call:didFailToConnectWithError:]>`</li>
      </ol>
    </td>
    <td>
      <ol>
        <li>`TVOCallStateConnecting`</li>
        <li>`TVOCallStateDisconnected`</li>
      </ol>
    </td>
   </tr>
   <tr>
    <td>A call is initiated and the call fails to connect after reaching the ringing state.</td>
    <td>
      <ol>
        <li>`<[TVOCallDelegate callDidStartRinging:]>`</li>
        <li>`<[TVOCallDelegate call:didFailToConnectWithError:]>`</li>
      </ol>
    </td>
    <td>
      <ol>
        <li>`TVOCallStateConnecting`</li>
        <li>`TVOCallStateRinging`</li>
        <li>`TVOCallStateDisconnected`</li>
      </ol>
    </td>
   </tr>
   <tr>
    <td>A call is initiated, becomes connected, and ends for one of the following reasons:
      <ul>
        <li>The caller disconnects the call</li>
        <li>The callee disconnects the call</li>
        <li>An on-device error occurs. (eg. network loss)</li>
        <li>An error between the caller and callee occurs. (eg. media connection lost or Twilio infrastructure failure)</li>
      </ul>
    </td>
    <td>
      <ol>
        <li>`<[TVOCallDelegate callDidStartRinging:]>`</li>
        <li>`<[TVOCallDelegate callDidConnect:]>`</li>
        <li>`<[TVOCallDelegate call:didDisconnectWithError:]>`</li>
      </ol>
    </td>
    <td>
      <ol>
        <li>`TVOCallStateConnecting`</li>
        <li>`TVOCallStateRinging`</li>
        <li>`TVOCallStateConnected`</li>
        <li>`TVOCallStateDisconnected`</li>
      </ol>
    </td>
   </tr>
   </table>
 
   The following table provides expected call sequences for common scenarios from the callee perspective:
 
   <table border="1" summary="Callee Scenarios">
   <tr>
    <td>Scenario</td><td>`<TVOCallDelegate>` Callbacks</td><td>`<TVOCallState>` Transitions</td>
   </tr>
   <tr>
    <td>A `<TVOCallInvite>` is accepted and the callee disconnects the call before being connected.</td>
    <td>
      <ol>
        <li>`<[TVOCallDelegate call:didDisconnectWithError:]>`</li>
      </ol>
    </td>
    <td>
      <ol>
        <li>`TVOCallStateConnecting`</li>
        <li>`TVOCallStateDisconnected`</li>
      </ol>
    </td>
   </tr>
   <tr>
    <td>A `<TVOCallInvite>` is accepted and the call fails to connect.</td>
    <td>
      <ol>
        <li>`<[TVOCallDelegate call:didFailToConnectWithError:]>`</li>
      </ol>
    </td>
    <td>
      <ol>
        <li>`TVOCallStateConnecting`</li>
        <li>`TVOCallStateDisconnected`</li>
      </ol>
    </td>
   </tr>
   <tr>
    <td>A `<TVOCallInvite>` is accepted, becomes connected, and ends for one of the following reasons:
      <ul>
        <li>The caller disconnects the call</li>
        <li>The callee disconnects the call</li>
        <li>An on-device error occurs. (eg. network loss)</li>
        <li>An error between the caller and callee occurs. (eg. media connection lost or Twilio infrastructure failure)</li>
      </ul>
    </td>
    <td>
      <ol>
        <li>`<[TVOCallDelegate callDidStartRinging:]>`</li>
        <li>`<[TVOCallDelegate callDidConnect:]>`</li>
        <li>`<[TVOCallDelegate call:didDisconnectWithError:]>`</li>
      </ol>
    </td>
    <td>
      <ol>
        <li>`TVOCallStateConnecting`</li>
        <li>`TVOCallStateRinging`</li>
        <li>`TVOCallStateConnected`</li>
        <li>`TVOCallStateDisconnected`</li>
      </ol>
    </td>
   </tr>
   </table>
 
 
   It is important to call the `<[TVOCall disconnect]>` method to terminate the call. Not calling `<[TVOCall disconnect]>`
   results in leaked native resources and may lead to an out-of-memory crash. If the call is disconnected by the
   caller, callee, or Twilio, the SDK will automatically free native resources. However, `<[TVOCall disconnect]>` is
   an idempotent operation so it is best to call this method when you are certain your application no longer needs
   the object.

   It is strongly recommended that `<TVOCall>` instances are created and accessed from a single dispatch queue.
   Accessing a `<TVOCall>` instance from multiple queues may cause synchronization problems. `<TVOCallDelegate>` methods
   are called on the main dispatch queue by default or on the `delegateQueue` provided to `<TVOConnectOptions>`
   or `<TVOAcceptOptions>` upon initiating or accepting a call.
 
   An ongoing call will automatically switch to a more preferred network type if one becomes available.
   The following are the network types listed in preferred order: `ETHERNET`, `LOOPBACK`, `WIFI`, `VPN`, and `CELLULAR`.
   For example, if a `WIFI` network becomes available whilst in a call that is using `CELLULAR` data, the call will automatically
   switch to using the `WIFI` network.
 
   Media and signaling reconnections are handled independently. As a result, it is possible that a single network change
   event produces consecutive `[TVOCallDelegate call:isReconnectingWithError:]` and `[TVOCallDelegate callDidReconnect:]`
   callbacks. For example, a network change may result in the following callback sequence.
 
   - `[TVOCallDelegate call:isReconnectingWithError:]` with `error.code` `TVOErrorSignalingConnectionDisconnectedError`.
   - `[TVOCallDelegate callDidReconnect:]`.
   - `[TVOCallDelegate call:isReconnectingWithError:]` with `error.code` `TVOErrorMediaConnectionError`.
   - `[TVOCallDelegate callDidReconnect:]`.
 
   Note that the SDK will always raise a `[TVOCallDelegate call:isReconnectingWithError:]` callback followed by a
   `[TVOCallDelegate callDidReconnect:]` callback when reconnection is successful.
 
   During the reconnecting state operations such as `[TVOCall setOnHold:]`, `[TVOCall setMuted:]`, `[TVOCall sendDigits:]` will result in
   undefined behavior. When building applications, the recommended practice is to show a UI update when the Call enters reconnecting
   regardless of the cause, and then clear the UI update once the call has reconnected or disconnected.
 
   **Insights**
 
   The following connection events are reported to Insights during a call:
 
   <table border="1" summary="Insights connection events">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>connection</td><td>muted</td><td>Audio input of the call is muted by calling `<[TVOCall setMuted:]>` with `YES`.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>unmuted</td><td>Audio input of the call is unmuted by calling `<[TVOCall setMuted:]>` with `NO`.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>accepted-by-remote</td><td>Server returns an answer to the Client’s offer over the signaling channel.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>ringing</td><td>Call state transitions to `TVOCallStateRinging`.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>connected</td><td>Call state transitions to `TVOCallStateConnected`.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>disconnect-called</td><td>`<[TVOCall disconnect]>` is called.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>disconnected-by-local</td><td>Call disconnected as a result of calling `<[TVOCall disconnect]>`. Call transitions to `TVOCallStateDisconnected`.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>disconnected-by-remote</td><td>Call is disconnected by the remote. Call transitions to `TVOCallStateDisconnected`.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>hold</td><td>Call is on hold by calling `<[TVOCall setOnHold:]>` with `YES`.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>unhold</td><td>Call is on unhold by calling `<[TVOCall setOnHold:]>` with `NO`.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>error</td><td>Error description. Call state transitions to `TVOCallStateDisconnected`.</td><td>3.0.0-beta2</td>
   </tr>
   <tr>
   <td>connection</td><td>reconnecting</td><td>The Call is attempting to recover from a signaling or media connection interruption</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>connection</td><td>reconnected</td><td>The Call has recovered from a signaling or media connection interruption</td><td>3.0.0-beta3</td>
   </tr>
   </table>
 
   The following peer connection state events are reported to Insights during a call:

   <table border="1" summary="Insights peer connection state events">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>pc-connection-state</td><td>new</td><td>The PeerConnection ice connection state changed to "new".</td><td>6.0.0</td>
   </tr>
   <tr>
   <td>pc-connection-state</td><td>connecting</td><td>The PeerConnection state changed to "connecting".</td><td>6.0.0</td>
   </tr>
   <tr>
   <td>pc-connection-state</td><td>connected</td><td>The PeerConnection state changed to "connected".</td><td>6.0.0</td>
   </tr>
   <tr>
   <td>pc-connection-state</td><td>disconnected</td><td>The PeerConnection state changed to "disconnected".</td><td>6.0.0</td>
   </tr>
   <tr>
   <td>pc-connection-state</td><td>failed</td><td>The PeerConnection state changed to "failed".</td><td>6.0.0</td>
   </tr>
   <tr>
   <td>pc-connection-state</td><td>closed</td><td>The PeerConnection state changed to "closed".</td><td>6.0.0</td>
   </tr>
   </table>

   The following ICE candidate event is reported to Insights during a call:
 
   <table border="1" summary="Insights ICE candidate events">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>ice-candidate</td><td>ice-candidate</td><td>ICE candidate events are raised when `OnIceCandidate` is called on the `PeerConnection`</td><td>4.1.0</td>
   </tr>
   <tr>
   <td>ice-candidate</td><td>selected-ice-candidate-pair</td><td>The active local ICE candidate and remote ICE candidate</td><td>6.0.0</td>
   </tr>
   </table>
 
   The following ICE connection state events are reported to Insights during a call:
 
   <table border="1" summary="Insights ICE connection events">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>ice-connection-state</td><td>new</td><td>The PeerConnection ice connection state changed to "new".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>ice-connection-state</td><td>checking</td><td>The PeerConnection ice connection state changed to "checking".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>ice-connection-state</td><td>connected</td><td>The PeerConnection ice connection state changed to "connected".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>ice-connection-state</td><td>completed</td><td>The PeerConnection ice connection state changed to "completed".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>ice-connection-state</td><td>closed</td><td>The PeerConnection ice connection state changed to "closed".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>ice-connection-state</td><td>disconnected</td><td>The PeerConnection ice connection state changed to "disconnected".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>ice-connection-state</td><td>failed</td><td>The PeerConnection ice connection state changed to "failed".</td><td>3.0.0-beta3</td>
   </tr>
   </table>
 
   The following ICE gathering state events are reported to Insights during a call:
 
   <table border="1" summary="Insights ICE gathering events">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>ice-gathering-state</td><td>new</td><td>The PeerConnection ice gathering state changed to "new".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>ice-gathering-state</td><td>gathering</td><td>The PeerConnection ice gathering state changed to "checking".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>ice-gathering-state</td><td>complete</td><td>The PeerConnection ice gathering state changed to "connected".</td><td>3.0.0-beta3</td>
   </tr>
   </table>
 
   The following signaling state events are reported to Insights during a call:
 
   <table border="1" summary="Insights peer connection signaling state events">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>signaling-state</td><td>stable</td><td>The PeerConnection signaling state changed to "stable".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>signaling-state</td><td>have-local-offer</td><td>The PeerConnection signaling state changed to "have-local-offer".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>signaling-state</td><td>have-remote-offers</td><td>The PeerConnection signaling state changed to "have-remote-offers".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>signaling-state</td><td>have-local-pranswer</td><td>The PeerConnection signaling state changed to "have-local-pranswer".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>signaling-state</td><td>have-remote-pranswer</td><td>The PeerConnection signaling state changed to "have-remote-pranswer".</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>signaling-state</td><td>closed</td><td>The PeerConnection signaling state changed to "closed".</td><td>3.0.0-beta3</td>
   </tr>
   </table>
 
   The following network quality warning and network quality warning cleared events are reported to Insights during a call:
 
   <table border="1" summary="Insights network quality events">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>network-quality-warning-raised</td><td>high-jitter</td><td>Three out of last five jitter samples exceed 30 ms.</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>network-quality-warning-cleared</td><td>high-jitter</td><td>high-jitter warning cleared if last five jitter samples are less than 30 ms.</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>network-quality-warning-raised</td><td>low-mos</td><td>Three out of last five mos samples are lower than 3.5.</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>network-quality-warning-cleared</td><td>low-mos</td><td>low-mos cleared if last five mos samples are higher than 3.5.</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>network-quality-warning-raised</td><td>high-packets-lost-fraction</td><td>The average packet loss > 3% in last 7 samples.</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>network-quality-warning-cleared</td><td>high-packets-lost-fraction</td><td>high-packets-lost-fraction cleared if average packet loss <= 1% in last 7 samples.</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>network-quality-warning-raised</td><td>high-rtt</td><td>Three out of last five RTT samples show greater than 400 ms.</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>network-quality-warning-cleared</td><td>high-rtt</td><td>high-rtt warning cleared if last five RTT samples are lower than 400 ms.</td><td>3.0.0-beta3</td>
   </tr>
   </table>
 
   The following audio level warning and audio level warning cleared events are reported to Insights during a call
 
   <table border="1" summary="Insights audio level events">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>audio-level-warning-raised</td><td>constant-audio-input-level</td><td>The standard deviation of audio input levels for last 10 samples is less than or equals 1% of the maximum possible audio input level (32767) i.e. 327.67 and the call is not in the muted state</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>audio-level-warning-cleared</td><td>constant-audio-input-level</td><td>constant-audio-input-level warning cleared if the standard deviation of audio input levels for last 10 samples is greater than 3% of the maximum possible audio input level.</td><td>3.0.0-beta3</td>
   </tr>
   </table>
 
   The following feedback events are reported to Insights during a call:
 
   <table border="1" summary="Insights feedback events">
   <tr>
   <td>Group Name</td><td>Event Name</td><td>Description</td><td>Since version</td>
   </tr>
   <tr>
   <td>feedback</td><td>received</td><td>`<[TVOCall postFeedback:issue:]>` is called if the score is not `TVOCallFeedbackScoreNotReported` or the issue type is not `TVOCallFeedbackIssueNotReported`.</td><td>3.0.0-beta3</td>
   </tr>
   <tr>
   <td>feedback</td><td>received-none</td><td>`<[TVOCall postFeedback:issue:]>` is called if the score is `TVOCallFeedbackScoreNotReported` and the issue type is `TVOCallFeedbackIssueNotReported`.</td><td>3.0.0-beta3</td>
   </tr>
   </table>
 */
NS_SWIFT_NAME(Call)
@interface TVOCall : NSObject

/**
 * @name Properties
 */

/**
 * @brief `From` value of the Call.
 *
 * @discussion This may be `nil` if the call object was created by calling the 
 * `<[TwilioVoiceSDK connectWithOptions:delegate:]>` method or if the call object was
 * created by calling the `<[TVOCallInvite acceptWithOptions:delegate:]>` method
 * where the `from` value of the `TVOCallInvite` object was also `nil`.
 */
@property (nonatomic, strong, readonly, nullable) NSString *from;

/**
 * @brief `To` value of the Call.
 *
 * @discussion This may be `nil` if the call object was created by calling the 
 * `<[TwilioVoiceSDK connectWithOptions:delegate:]>` method.
 */
@property (nonatomic, strong, readonly, nullable) NSString *to;

/**
 * @brief A server assigned identifier (SID) for the Call.
 *
 * @discussion A SID is a globally unique identifier which can be very useful for debugging Call traffic. The Call sid
 * may be `nil` until the call is in `TVOCallStateRinging` state.
 */
@property (nonatomic, strong, readonly, nonnull) NSString *sid;

/**
 * @brief Property that defines if the Call is muted.
 *
 * @discussion The Voice SDK's media engine will start sending silent audio frames when the Call is muted. Setting the
 * property will only take effect if the `<state>` is `TVOCallStateConnected`.
 */
@property (nonatomic, assign, getter=isMuted) BOOL muted;

/**
 * @brief The current state of the Call.
 *
 * @discussion All `TVOCall` instances start in `TVOCallStateConnecting` and end in `TVOCallStateDisconnected`.
 * After creation, a Call will transition to `TVOCallStateConnected` if successful or `TVOCallStateDisconnected` if the
 * connection attempt fails.
 *
 * @see TVOCallState
 */
@property (nonatomic, assign, readonly) TVOCallState state;

/**
 * @brief Property that defines if the Call is on hold.
 *
 * @discussion If the Call is on hold, The Voice SDK's media engine will send silent audio frames to the remote party,
 * and remote party's audio playback will be disabled.
 */
@property (nonatomic, getter=isOnHold) BOOL onHold;

/**
 * @brief The current set of Call quality warnings.
 *
 * @discussion Values in the `<NSSet`> are `<NSNumber>` with values of `<TVOCallQualityWarning>`.
 */
@property (nonatomic, strong, readonly, nonnull) NSSet *callQualityWarnings;

/**
 * @name General Call Actions
 */

/**
 * @brief Disconnects the Call.
 *
 * @discussion Calling this method on a `TVOCall` that is in the `<state>` `TVOCallStateDisconnected` has no effect.
 */
- (void)disconnect;

/**
 * @brief Send a string of digits.
 *
 * @discussion Calling this method on a `TVOCall` that is not in the `<state>` `TVOCallStateConnected` has no effect.
 *
 * @param digits A string of characters to be played. Valid values are '0' - '9', '*', '#', and 'w'.
 *               Each 'w' will cause a 500 ms pause between digits sent.
 */
- (void)sendDigits:(nonnull NSString *)digits;

/**
 * @brief Retrieve stats for the audio track.
 *
 * @param block The block to be invoked when the stats are available.
 */
- (void)getStatsWithBlock:(nonnull TVOCallGetStatsBlock)block
NS_SWIFT_NAME(getStats(_:));

/**
 * @brief Posts the feedback collected for this Call to Twilio.
 *
 * @discussion If `TVOCallFeedbackScoreNotReported` and `TVOCallFeedbackIssueNotReported` are passed, Twilio will report feedback was not available for this call.
 *
 * @param score The quality score of the Call.
 * @param issue The issue associated with the Call.
 *
 * @see TVOCallFeedbackScore
 * @see TVOCallFeedbackIssue
 */
- (void)postFeedback:(TVOCallFeedbackScore)score issue:(TVOCallFeedbackIssue)issue
NS_SWIFT_NAME(postFeedback(score:issue:));

/**
 * @brief Call cannot be instantiated directly. Use `[TVOCallInvite acceptWithOptions:delegate:]` and `[TwilioVoiceSDK connectWithOptions:delegate:]`.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("A `TVOCall` object cannot be instantiated directly. See `[TVOCallInvite acceptWithOptions:delegate:]` or `[TwilioVoiceSDK connectWithOptions:delegate:]`")));

@end

/**
 *  CallKit specific additions.
 */
@interface TVOCall (CallKit)

/**
 * @brief A unique identifier for the Call.
 *
 * @discussion Use this UUID as an argument to CallKit methods.
 * You can provide a UUID for outgoing calls using `<[TwilioVoiceSDK connectWithOptions:delegate:]>`.
 * Calls created via `<[TVOCallInvite acceptWithOptions:delegate:]>` inherit their `uuid` from the Invite itself.
 */
@property (nonatomic, strong, readonly, nullable) NSUUID *uuid;

@end
