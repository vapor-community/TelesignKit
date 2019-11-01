//
//  TelesignClient.swift
//  
//
//  Created by Andrew Edwards on 10/23/19.
//

import NIO
import AsyncHTTPClient

public final class TelesignClient {
    private let client: HTTPClient
    public let messaging: MessageRoute
    public let score: ScoreRoute
    public let phone: PhoneRoute
    
    public init(eventLoop: EventLoopGroup,
                apiKey: String,
                customerId: String) {
        client = HTTPClient(eventLoopGroupProvider: .shared(eventLoop))
        let telesignRequest = TelesignAPIRequest(apiKey: apiKey,
                                                 customerId: customerId,
                                                 httpClient: client)
        messaging = Messaging(request: telesignRequest)
        score = Score(request: telesignRequest)
        phone = Phone(request: telesignRequest)
    }
    
    deinit {
        try? client.syncShutdown()
    }
}
