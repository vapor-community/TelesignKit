//
//  TelesignClient.swift
//  
//
//  Created by Andrew Edwards on 10/23/19.
//

import NIO
import AsyncHTTPClient

public final class TelesignClient {
    public var messaging: MessageRoute
    public var score: ScoreRoute
    public var phone: PhoneRoute
    
    var requester: TelesignAPIRequest
    
    public init(httpClient: HTTPClient,
                eventLoop: EventLoop,
                apiKey: String,
                customerId: String) {

        requester = TelesignAPIRequest(apiKey: apiKey,
                                       customerId: customerId,
                                       httpClient: httpClient,
                                       eventLoop: eventLoop)
        messaging = Messaging(request: requester)
        score = Score(request: requester)
        phone = Phone(request: requester)
    }
    
    public func hopped(to eventLoop: EventLoop) -> TelesignClient {
        requester.eventLoop = eventLoop
        return self
    }
}
