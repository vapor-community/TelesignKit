//
//  TelesignClient.swift
//  
//
//  Created by Andrew Edwards on 10/23/19.
//

import NIO
import AsyncHTTPClient

public final class TelesignClient {
    public let messaging: MessageRoute
    public let score: ScoreRoute
    public let phone: PhoneRoute
    
    public init(httpClient: HTTPClient,
                eventLoop: EventLoop,
                apiKey: String,
                customerId: String) {

        let telesignRequest = TelesignAPIRequest(apiKey: apiKey,
                                                 customerId: customerId,
                                                 httpClient: httpClient,
                                                 eventLoop: eventLoop)
        messaging = Messaging(request: telesignRequest)
        score = Score(request: telesignRequest)
        phone = Phone(request: telesignRequest)
    }
}
