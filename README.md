# TelesignKit

![](https://img.shields.io/badge/Swift-5-lightgrey.svg?style=svg)
![](https://img.shields.io/badge/SwiftNio-2-lightgrey.svg?style=svg)


### TelesignKit is a Swift package used to communicate with the [Telesign](https://telesign.com) API for Server Side Swift Apps.

## What's Telesign?
[Telesign](https://www.telesign.com) is a Communication Platform as a Service. Allowing you to send SMS messages for your use case, text to voice communications, phone identification to reduce risk/fraud and many other things.

## Installation
To start using TelesignKit, in your `Package.swift`, add the following

~~~~swift
.package(url: "https://github.com/vapor-community/telesignkit.git", from: "1.0.0")
~~~~

## Using the API

In your `main.swift` simply create a `TelesignClient`:

~~~swift
import NIO
import TelesignKit

let eventloop: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)


let client = TelesignClient(eventLoop: eventloop,
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

## Supports the following APIs
* [x] Messaging
* [x] PhoneId
* [x] Score
