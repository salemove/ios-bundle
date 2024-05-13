//
//  TVOError.h
//  TwilioVoice
//
//  Copyright © 2018 Twilio, Inc. All rights reserved.
//

#ifndef TVOError_h
#define TVOError_h

FOUNDATION_EXPORT NSString * _Nonnull const kTVOErrorDomain
NS_SWIFT_NAME(TwilioVoiceSDK.ErrorDomain);

/**
 * An enumeration indicating the errors that can be raised by the SDK.
 */
typedef NS_ERROR_ENUM(kTVOErrorDomain, TVOError) {
    TVOErrorAccessTokenInvalidError                       = 20101,    ///< Invalid Access Token
    TVOErrorAccessTokenHeaderInvalidError                 = 20102,    ///< Invalid Access Token header
    TVOErrorAccessTokenIssuerInvalidError                 = 20103,    ///< Invalid Access Token issuer/subject
    TVOErrorAccessTokenExpiredError                       = 20104,    ///< Access Token expired or expiration date invalid
    TVOErrorAccessTokenNotYetValidError                   = 20105,    ///< Access Token not yet valid
    TVOErrorAccessTokenGrantsInvalidError                 = 20106,    ///< Invalid Access Token grants
    TVOErrorAccessTokenSignatureInvalidError              = 20107,    ///< Invalid Access Token signature
    TVOErrorAuthFailureCodeError                          = 20151,    ///< Auth Failure Error
    TVOErrorExpirationTimeExceedsMaxTimeAllowedError      = 20157,    ///< Expiration Time Exceeds Maximum Time Allowed
    TVOErrorAccessForbiddenError                          = 20403,    ///< The account lacks permission to access the Twilio API
    TVOErrorApplicationNotFoundError                      = 21218,    ///< Invalid Application Sid
    TVOErrorConnectionError                               = 31005,    ///< Connection error
    /**
     * This error indicates that the incoming call was cancelled because it was not answered in time
     * or it was accepted/rejected by another application instance registered with the same identity.
     */
    TVOErrorCallCancelledError                            = 31008,    ///< Unable to answer because the call has ended
    TVOErrorTransportError                                = 31009,    ///< No transport available to send or receive messages
    TVOErrorMalformedRequestError                         = 31100,    ///< Malformed request
    TVOErrorAuthorizationError                            = 31201,    ///< Authorization error
    TVOErrorRegistrationError                             = 31301,    ///< Registration error
    TVOErrorUnsupportedCancelMessageError                 = 31302,    ///< Unsupported Cancel Message Error
    TVOErrorBadRequestError                               = 31400,    ///< The request could not be understood due to malformed syntax
    TVOErrorForbiddenError                                = 31403,    ///< The server understood the request, but is refusing to fulfill it
    TVOErrorNotFoundError                                 = 31404,    ///< The server has not found anything matching the request
    TVOErrorRequestTimeoutError                           = 31408,    ///< A request timeout occurred
    TVOErrorConflictError                                 = 31409,    ///< The request could not be processed because of a conflict in the current state of the resource. Another request may be in progress
    TVOErrorUpgradeRequiredError                          = 31426,    ///< This error is raised when an HTTP 426 response is received. The reason for this is most likely because of an incompatible TLS version. To mitigate this, you may need to upgrade the OS or download a more recent version of the SDK.
    TVOErrorTooManyRequestsError                          = 31429,    ///< Too many requests were sent in a given amount of time
    TVOErrorTemporarilyUnavailableError                   = 31480,    ///< The callee is currently unavailable
    TVOErrorCallDoesNotExistError                         = 31481,    ///< The call no longer exists
    TVOErrorAddressIncompleteError                        = 31484,    ///< The phone number is malformed
    TVOErrorBusyHereError                                 = 31486,    ///< The callee is busy
    TVOErrorRequestTerminatedError                        = 31487,    ///< The request has terminated as a result of a bye or cancel
    TVOErrorInternalServerError                           = 31500,    ///< The server could not fulfill the request due to some unexpected condition
    TVOErrorBadGatewayError                               = 31502,    ///< The server is acting as a gateway or proxy, and received an invalid response from a downstream server while attempting to fulfill the request
    TVOErrorServiceUnavailableError                       = 31503,    ///< The server is currently unable to handle the request due to a temporary overloading or maintenance of the server
    TVOErrorGatewayTimeoutError                           = 31504,    ///< The server, while acting as a gateway or proxy, did not receive a timely response from an upstream server
    TVOErrorDNSResolutionError                            = 31530,    ///< Could not connect to the server due to DNS resolution failure
    TVOErrorBusyEverywhereError                           = 31600,    ///< All possible destinations are busy
    TVOErrorDeclineError                                  = 31603,    ///< The callee does not wish to participate in the call
    TVOErrorDoesNotExistAnywhereError                     = 31604,    ///< The requested callee does not exist anywhere
    TVOErrorTokenAuthenticationRejected                   = 51007,    ///< Token authentication is rejected by authentication service
    TVOErrorSignalingConnectionDisconnectedError          = 53001,    ///< Signaling connection disconnected
    TVOErrorMediaClientLocalDescFailedError               = 53400,    ///< Client is unable to create or apply a local media description
    TVOErrorMediaServerLocalDescFailedError               = 53401,    ///< Server is unable to create or apply a local media description
    TVOErrorMediaClientRemoteDescFailedError              = 53402,    ///< Client is unable to apply a remote media description
    TVOErrorMediaServerRemoteDescFailedError              = 53403,    ///< Server is unable to apply a remote media description
    TVOErrorMediaNoSupportedCodecError                    = 53404,    ///< No supported codec
    TVOErrorMediaConnectionError                          = 53405,    ///< Media connection failed
    TVOMediaDtlsTransportFailedErrorCode                  = 53407,    ///< Media connection failed due to DTLS handshake failure
}
NS_SWIFT_NAME(TwilioVoiceSDK.Error);

#endif
