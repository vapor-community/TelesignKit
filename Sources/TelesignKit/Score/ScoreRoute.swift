//
//  ScoreRoute.swift
//  Telesign
//
//  Created by Andrew Edwards on 7/25/17.
//
//

import NIO

public protocol ScoreRoute {
    func getScore(phoneNumber: String,
                  accountLifecycleEvent: AccountLifecycleEvent,
                  originatingIp: String?,
                  deviceId: String?,
                  accountId: String?,
                  emailAddress: String?) -> EventLoopFuture<TelesignScoreResponse>
}

extension ScoreRoute {
    public func getScore(phoneNumber: String,
                         accountLifecycleEvent: AccountLifecycleEvent,
                         originatingIp: String? = nil,
                         deviceId: String? = nil,
                         accountId: String? = nil,
                         emailAddress: String? = nil) -> EventLoopFuture<TelesignScoreResponse> {
        return getScore(phoneNumber: phoneNumber,
                        accountLifecycleEvent: accountLifecycleEvent,
                        originatingIp: originatingIp,
                        deviceId: deviceId,
                        accountId: accountId,
                        emailAddress: emailAddress)
    }
}

public struct Score: ScoreRoute {
    private let request: TelesignRequest
    
    init(request: TelesignRequest) {
        self.request = request
    }
    
    public func getScore(phoneNumber: String,
                         lifecycleEvent: AccountLifecycleEvent,
                         originatingIp: String?,
                         deviceId: String?,
                         accountId: String?,
                         emailAddress: String?) -> EventLoopFuture<TelesignScoreResponse> {
        var bodyData = ["account_lifecycle_event": lifecycleEvent.rawValue]
        
        if let ip = originatingIp {
            bodyData["originating_ip"] = ip
        }

        if let device = deviceId {
            bodyData["device_id"] = device
        }

        if let account = accountId {
            bodyData["account_id"] = account
        }

        if let email = emailAddress {
            bodyData["email_address"] = email
        }
        
        return request.send(method: .POST, path: "/v1/score/\(phoneNumber)", body: bodyData.queryParameters)
    }
}
