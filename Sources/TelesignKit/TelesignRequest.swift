//
//  TelesignRequest.swift
//  Telesign
//
//  Created by Andrew Edwards on 7/21/17.
//
//

import Foundation
import NIO
import NIOFoundationCompat
import NIOHTTP1
import AsyncHTTPClient
import Crypto

public protocol TelesignRequest {
    func send<TM: TelesignModel>(method: HTTPMethod, path: String, body: String) -> EventLoopFuture<TM>
    func generateHeaders(path: String,
                         method: HTTPMethod,
                         body: String,
                         date: Date,
                         apiKey: String,
                         customerId: String) -> HTTPHeaders
}

extension TelesignRequest {
    public func send<TM: TelesignModel>(method: HTTPMethod,
                                        path: String,
                                        body: String = "") -> EventLoopFuture<TM> {
        return send(method: method, path: path, body: body)
    }
    
    public func generateHeaders(path: String,
                                method: HTTPMethod,
                                body: String,
                                date: Date = Date(),
                                apiKey: String,
                                customerId: String) -> HTTPHeaders {
        let contentType = (method == .POST || method == .PUT) ? "application/x-www-form-urlencoded" : ""
        
        let authMethod = "HMAC-SHA256"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss z"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = formatter.string(from: date)
        
        var stringToSignArray = ["\(method.rawValue)\n",
                                 "\(contentType)\n",
                                 "\n",
                                 "x-ts-auth-method:\(authMethod)\n",
                                 "x-ts-date:\(date)\n"]
        
        stringToSignArray.append("\(body)\n")
        stringToSignArray.append("\(path)")
        
        let stringToSign = (stringToSignArray.joined(separator: "").removingPercentEncoding ?? "").data(using: .utf8)!
        let key = SymmetricKey(data: Data(base64Encoded: apiKey, options: Data.Base64DecodingOptions(rawValue: 0)) ?? Data())
        let hash = HMAC<SHA256>.authenticationCode(for: stringToSign,
                                                   using: key)
        let signature = Data(hash).base64EncodedString()
                
        let authorization = "TSA \(customerId):\(signature)"
        
        let headers: HTTPHeaders = ["authorization": authorization,
                                    "Content-Type": contentType,
                                    "x-ts-date": "\(date)",
                                    "x-ts-auth-method": authMethod]
        return headers
    }
}

public class TelesignAPIRequest: TelesignRequest {
    private let uri = "https://rest-api.telesign.com"
    private let decoder = JSONDecoder()
    private let apiKey: String
    private let customerId: String
    private let httpClient: HTTPClient
    private let eventLoop: EventLoop
    
    init(apiKey: String, customerId: String, httpClient: HTTPClient, eventLoop: EventLoop) {
        self.apiKey = apiKey
        self.customerId = customerId
        self.httpClient = httpClient
        self.eventLoop = eventLoop
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func send<TM: TelesignModel>(method: HTTPMethod, path: String, body: String) -> EventLoopFuture<TM> {
        let headers = generateHeaders(path: path, method: method, body: body, apiKey: apiKey, customerId: customerId)
        
        do {
            let request = try HTTPClient.Request(url: "\(uri)/\(path)", method: method, headers: headers, body: .string(body))
            
            return httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop)).flatMap { response in
                guard var byteBuffer = response.body else {
                    fatalError("Response body from Telesign is missing! This should never happen.")
                }
                let responseData = byteBuffer.readData(length: byteBuffer.readableBytes)!
                
                do {
                    guard response.status == .ok else {
                        return self.eventLoop.makeFailedFuture(try self.decoder.decode(TelesignError.self, from: responseData))
                    }
                    return self.eventLoop.makeSucceededFuture(try self.decoder.decode(TM.self, from: responseData))

                } catch {
                    return self.eventLoop.makeFailedFuture(error)
                }
            }
        } catch {
            return self.eventLoop.makeFailedFuture(error)
        }
    }
}
