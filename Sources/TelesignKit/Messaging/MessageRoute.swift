//
//  Messaging.swift
//  Telesign
//
//  Created by Andrew Edwards on 7/20/17.
//
//

import NIO

public protocol MessageRoute {
    
    /// Send a message (with a verification code if you wish), specify the type of message, what phase of the account lifecycle the message is being sent in, and additional details about the transaction.
    /// - Parameter phoneNumber: The end users phone number with country code included. Avoid use of special characters and spaces.
    /// - Parameter message: Text of the message to be sent to the end user. You are limited to 1600 characters. If you send a very long message, TeleSign splits your message into separate parts. TeleSign recommends against sending messages that require multiple SMSes when possible.
    /// - Parameter messageType: This parameter specifies the traffic type being sent in the message. You can provide one of the following values - `OTP (One time passwords)`, `ARN (Alerts, reminders, and notifications)`, `MKT (Marketing traffic).`
    /// - Parameter accountLifecycleEvent: This parameter allows you to indicate what phase of the lifecycle you are in when you send a transaction. The options for this parameter are - `create - For the creation of a new account.`, `sign-in - For when an end user signs in to their account.`,  `transact - For when an end user completes a transaction within their account.`,  `update - For when an update is performed, such as an update of account information or similar.`, `delete - For when an account is deleted.`.
    /// - Parameter senderId: This parameter allows you to set a specific sender ID to be used on an SMS message sent to the end user. In order to use a specific sender ID, TeleSign must whitelist your selected sender ID values. Be aware that 100% preservation of a sender ID value is not guaranteed. TeleSign may override the sender ID value that your end user will receive in order to improve delivery quality or follow SMS regulations in particular countries. In order to use this feature, you must contact TeleSign Support and have them enable it for you.
    /// - Parameter externalId: You can mark each of your requests with your own identifier. This identifier is returned as part of a delivery receipt (DLR) callback.
    /// - Parameter originatingIp: Your end user’s IP address (do not send your own IP address). This value must be in the format defined by the Internet Engineering Task Force (IETF) in the Internet-Draft document titled.
    func send(phoneNumber: String,
              message: String,
              messageType: MessageType,
              accountLifecycleEvent: AccountLifecycleEvent?,
              senderId: String?,
              externalId: String?,
              originatingIp: String?) -> EventLoopFuture<TelesignMessageResponse>
    
    /// Get the current status of a message.
    /// - Parameter reference: A unique identifier you can use to query the Messaging API and find out the status of your transaction.
    func getStatusFor(reference: String) -> EventLoopFuture<TelesignMessageResponse>
}

extension MessageRoute {
    func send(phoneNumber: String,
              message: String,
              messageType: MessageType,
              accountLifecycleEvent: AccountLifecycleEvent? = nil,
              senderId: String? = nil,
              externalId: String? = nil,
              originatingIp: String? = nil) -> EventLoopFuture<TelesignMessageResponse> {
        return send(phoneNumber: phoneNumber,
                    message: message,
                    messageType: messageType,
                    accountLifecycleEvent: accountLifecycleEvent,
                    senderId: senderId,
                    externalId: externalId,
                    originatingIp: originatingIp)
    }

    public func getStatusFor(reference: String) -> EventLoopFuture<TelesignMessageResponse> {
        return getStatusFor(reference: reference)
    }
}

public struct Messaging: MessageRoute {
    private let request: TelesignRequest
    
    init(request: TelesignRequest) {
        self.request = request
    }
    
    public func send(phoneNumber: String,
                     message: String,
                     messageType: MessageType,
                     accountLifecycleEvent: AccountLifecycleEvent? = nil,
                     senderId: String? = nil,
                     externalId: String? = nil,
                     originatingIp: String? = nil) -> EventLoopFuture<TelesignMessageResponse> {
        
        var bodyData = ["phone_number": phoneNumber,
                        "message": message,
                        "message_type": messageType.rawValue]
        
        if let ale = accountLifecycleEvent {
            bodyData["account_lifecycle_event"] = ale.rawValue
        }
        
        if let senderId = senderId {
            bodyData["sender_id"] = senderId
        }
        
        if let externalId = externalId {
            bodyData["external_id"] = externalId
        }
        
        if let ip = originatingIp {
            bodyData["originating_ip"] = ip
        }
        
        return request.send(method: .POST, path: "/v1/messaging", body: bodyData.queryParameters)
    }
    
    public func getStatusFor(reference: String) -> EventLoopFuture<TelesignMessageResponse> {
        return request.send(method: .GET, path: "/v1/messaging/\(reference)")
    }
}
