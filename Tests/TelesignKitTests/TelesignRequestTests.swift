//
//  TelesignRequestTests.swift
//  TelesignKitTests
//
//  Created by Andrew Edwards on 12/2/17.
//

import XCTest
@testable import TelesignKit
@testable import OpenCrypto
@testable import NIOHTTP1

class TelesignRequestTests: XCTestCase {
    struct MockTelesignRequest: TelesignRequest {}
    
    func testGenerateHeaders() {
        let apiKey = "ZZdFizzwc8cv+xzzYp7kw8UkZdpC+kOZeHl4Udubdu4Vys3hOI83G1bbRXPqvIiE48miLoa3XgyEPFzYuQuj2A=="
        let customerId = "myCustomerId"

        let body = "message=Your reset code is 610190. This code will expire in 10 minutes.&phone_number=1234567890&message_type=ARN"
        
        let req = MockTelesignRequest()
        let headers = req.generateHeaders(path: "/v1/messaging",
                                          method: .POST,
                                          body: body,
                                          date: Date(timeIntervalSince1970: 1572662495),
                                          apiKey: apiKey,
                                          customerId: customerId)
        
        XCTAssertEqual(headers["authorization"].first, "TSA myCustomerId:v03YU8XGGRgHrUl8cCEVWKcQLRN/zNKd+PcW6bsRI3c=")
        XCTAssertEqual(headers["x-ts-date"].first, "Sat, 2 Nov 2019 02:41:35 GMT")
        XCTAssertEqual(headers["x-ts-auth-method"].first, "HMAC-SHA256")
        XCTAssertEqual(headers["Content-Type"].first, "application/x-www-form-urlencoded")
    }
}
