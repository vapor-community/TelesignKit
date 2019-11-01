//
//  PhoneId.swift
//  Telesign
//
//  Created by Andrew Edwards on 7/24/17.
//
//

import NIO

public protocol PhoneRoute {
    func getId(for number: String, lifecycleEvent: AccountLifecycleEvent?, originatingIp: String?) -> EventLoopFuture<TelesignPhoneIdResponse>
}

extension PhoneRoute {
    public func getId(for number: String, lifecycleEvent: AccountLifecycleEvent? = nil, originatingIp: String? = nil) -> EventLoopFuture<TelesignPhoneIdResponse> {
        return getId(for: number, lifecycleEvent: lifecycleEvent, originatingIp: originatingIp)
    }
}

public struct Phone: PhoneRoute {
    private var request: TelesignRequest
    
    init(request: TelesignRequest) {
        self.request = request
    }

    public func getId(for number: String, lifecycleEvent: AccountLifecycleEvent?, originatingIp: String?) -> EventLoopFuture<TelesignPhoneIdResponse> {
        var bodyData: [String: String] = [:]
        
        if let ale = lifecycleEvent {
            bodyData["account_lifecycle_event"] = ale.rawValue
        }

        if let ip = originatingIp {
            bodyData["originating_ip"] = ip
        }
        
        return request.send(method: .POST, path: "/v1/phoneid/\(number)", body: bodyData.queryParameters)
    }
}
