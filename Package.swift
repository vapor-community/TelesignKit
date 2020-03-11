// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "telesign-kit",
    platforms: [ .macOS(.v10_15)],
    products: [
        .library(name: "TelesignKit", targets: ["TelesignKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", .exact("1.1.0")),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "TelesignKit", dependencies: [
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "Crypto", package: "swift-crypto")
        ]),
        .testTarget(name: "TelesignKitTests", dependencies: [
            .target(name: "TelesignKit")
        ])
    ]
)
