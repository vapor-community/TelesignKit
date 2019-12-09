// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TelesignKit",
    platforms: [ .macOS(.v10_14)],
    products: [
        .library(name: "TelesignKit", targets: ["TelesignKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/open-crypto.git", from: "4.0.0-beta")
    ],
    targets: [
        .target(name: "TelesignKit", dependencies: ["AsyncHTTPClient", "NIOFoundationCompat", "OpenCrypto"]),
        .testTarget(name: "TelesignKitTests", dependencies: ["AsyncHTTPClient", "TelesignKit"])
    ]
)
