//
//  TVOCallDelegate.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

@class TVOCall;

/**
 *  `TVOCallDelegate` provides callbacks when important changes to a `TVOCall` occur.
 */
NS_SWIFT_NAME(CallDelegate)
@protocol TVOCallDelegate <NSObject>

/**
 * @name Required Methods
 */

/**
 * @brief Notifies the delegate that a Call has connected.
 *
 * @param call The `<TVOCall>` that was connected.
 *
 * @see TVOCall
 */
- (void)callDidConnect:(nonnull TVOCall *)call
NS_SWIFT_NAME(callDidConnect(call:));

/**
 * @brief Notifies the delegate that a Call has failed to connect.
 *
 * @param call The `<TVOCall>` that failed to connect.
 * @param error The `<NSError>` that occurred.
 *
 * @see TVOCall
 */
- (void)call:(nonnull TVOCall *)call didFailToConnectWithError:(nonnull NSError *)error
NS_SWIFT_NAME(callDidFailToConnect(call:error:));

/**
 * @brief Notifies the delegate that a Call has disconnected.
 *
 * @param call The `<TVOCall>` that was disconnected.
 * @param error An `NSError` describing why disconnect occurred, or `nil` if the disconnect was expected.
 *
 * @see TVOCall
 */
- (void)call:(nonnull TVOCall *)call didDisconnectWithError:(nullable NSError *)error
NS_SWIFT_NAME(callDidDisconnect(call:error:));

/**
 * @name Optional Methods
 */

@optional
/**
 * @brief Notifies the delegate that the called party is being alerted of a Call.
 *
 * @param call The `<TVOCall>` that the called party is being alerted of.
 *
 * @discussion This callback is invoked once before the `[TVOCallDelegate callDidConnect:]` callback. If
 * the `answerOnBridge` is `true` this represents the callee is being alerted of a Call.
 *
 * @see TVOCall
 */
- (void)callDidStartRinging:(nonnull TVOCall *)call
NS_SWIFT_NAME(callDidStartRinging(call:));

/**
 * @brief Notifies the delegate that a Call starts to reconnect due to network change event.
 *
 * @discussion Reconnect is triggered when a network change is detected and Call is already in `TVOCallStateConnected` state.
 * If the call is either in `TVOCallStateConnecting` or in `TVOCallStateRinging` when network change happened
 * then the current call will disconnect.
 *
 * @param call The `<TVOCall>` that is reconnecting.
 * @param error The `<NSError>` that describes the reconnect reason. This would have one of the two possible values
 * with error codes `TVOErrorSignalingConnectionDisconnectedError` and `TVOErrorMediaConnectionError`.
 *
 * @see TVOCall
 */
- (void)call:(nonnull TVOCall *)call isReconnectingWithError:(nonnull NSError *)error
NS_SWIFT_NAME(callIsReconnecting(call:error:));

/**
 * @brief Notifies the delegate that a Call is reconnected.
 *
 * @param call The `<TVOCall>` that is reconnected.
 *
 * @see TVOCall
 */
- (void)callDidReconnect:(nonnull TVOCall *)call
NS_SWIFT_NAME(callDidReconnect(call:));

/**
 * @brief Notifies the delegate that network quality warnings have changed for the Call.
 *
 * @param call The `< TVOCall>` that received quality warning updates.
 * @param currentWarnings An `<NSSet>` that contains the warnings at the instant of receiving this callback. Values in the `<NSSet`> are `<NSNumber>` with values of `<TVOCallQualityWarning>`.
 * @param previousWarnings An `<NSSet>` that contains the warnings before receiving this callback. Values in the `<NSSet`> are `<NSNumber>` with values of `<TVOCallQualityWarning>`.
 *
 * @discussion The trigger conditions for the warnings defined in the `<TVOCallQualityWarning>` enumeration are defined as follows:
 *
 * - `TVOCallQualityWarningHighRtt` - Round Trip Time (RTT) > 400 ms for 3 out of last 5 samples.
 * - `TVOCallQualityWarningHighJitter` - Jitter > 30 ms for 3 out of last 5 samples.
 * - `TVOCallQualityWarningHighPacketsLostFraction` - Raised when average packet loss > 3% in last 7 samples. Cleared when average packet loss <= 1% in last 7 samples.
 * - `TVOCallQualityWarningLowMos` - Mean Opinion Score (MOS) < 3.5 for 3 out of last 5 samples.
 * - `TVOCallQualityWarningConstantAudioInputLevel` - Raised when the standard deviation of audio input levels for last 10 samples is less than or equals 1% of the maximum possible audio input level (32767) i.e. 327.67 and the call is not in the muted state. Cleared when the standard deviation of audio input levels for last 10 samples is greater than 3% of the maximum possible audio input level.
 *
 * The two sets will help the delegate find out what warnings have changed since the last callback was received.
 */
- (void)call:(nonnull TVOCall *)call
didReceiveQualityWarnings:(nonnull NSSet<NSNumber *> *)currentWarnings
previousWarnings:(nonnull NSSet<NSNumber *> *)previousWarnings
NS_SWIFT_NAME(callDidReceiveQualityWarnings(call:currentWarnings:previousWarnings:));

@end
