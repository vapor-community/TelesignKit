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
    // TODO: - Fix later.
    func testGenerateHeaders() {
//        let apiKey = "rSXsJDSK2hWi1CtzX/RbPtuTnZ7dybjFVS7gcJKkhqXa4RRQ5gkbP3TGNUwiqpu0cXxG5oblzu19X51//aIRLw=="
//        let customerId = "Hello"
//
//        let body = "message=Your reset code is 610190. This code will expire in 10 minutes.&phone_number=1234567890&message_type=ARN"
//        let headers = api.generateHeaders(path: "/v1/messaging", method: .POST, body: body, apiKey: apiKey, customerId: customerId)
//        XCTAssert(headers.contains(name: "authorization"))
//        XCTAssert(headers.contains(name: "x-ts-date"))
//        XCTAssert(headers.contains(name: "x-ts-auth-method"))
//        XCTAssertEqual(headers["Content-Type"][0], "application/x-www-form-urlencoded")
    }
}
