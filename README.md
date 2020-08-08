# TelesignKit

![](https://img.shields.io/badge/Swift-5.2-lightgrey.svg?style=svg)
![](https://img.shields.io/badge/SwiftNio-2-lightgrey.svg?style=svg)


### TelesignKit is a Swift package used to communicate with the [Telesign](https://telesign.com) API for Server Side Swift Apps.

## What's Telesign?
[Telesign](https://www.telesign.com) is a Communication Platform as a Service. Allowing you to send SMS messages for your use case, text to voice communications, phone identification to reduce risk/fraud and many other things.

## Installation
To start using TelesignKit, in your `Package.swift`, add the following

~~~~swift
.package(url: "https://github.com/vapor-community/telesignkit.git", from: "3.0.0")
~~~~

## Using the API

In your `main.swift` simply create a `TelesignClient`:

~~~swift
import NIO
import TelesignKit

let httpClient = HTTPClient(..)

let client = TelesignClient(httpClient: httpClient,
                            eventLoop: eventloop,
                            apiKey: "YOUR_API_KEY",
                            customerId: "YOUR_CUSTOMER_ID")

do {
    let result = try client.messaging.send(phoneNumber: "11234567890",
                                           message: "Hello Telesign!",
                                           messageType: .ARN).wait()
    print(result)
} catch {
    print(error)
}
~~~

## Vapor Integration
To use TelesignKit with Vapor 4.x, add a simple extension on `Request`.
~~~swift
extension Request {
    public var telesign: TelesignClient {
    return TelesignClient(httpClient: self.application.client.http, eventLoop: self.eventLoop, apiKey: "TELESIGN_API_KEY", customerId: "CUSTOMER_ID")
    }
}

// Later...

func sendSMS(req: Request) -> EventLoopFuture<Response> {
    return req.telesign.messaging.send(...)
}
~~~

## Supports the following APIs
* [x] Messaging
* [x] PhoneId
* [x] Score
