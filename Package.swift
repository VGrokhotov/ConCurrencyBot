// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConCurrencyBot",
    platforms: [
            .macOS(.v10_14),
        ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2"),
        .package(url: "https://github.com/yahoojapan/SwiftyXMLParser.git", from: "5.3.0"),
        .package(url: "https://github.com/givip/Telegrammer", from: "1.0.0-alpha.1"),
    ],
    targets: [
        .target(
            name: "ConCurrencyBot",
            dependencies: ["SwiftSoup", "SwiftyXMLParser", "Telegrammer"]),
        .testTarget(
            name: "ConCurrencyBotTests",
            dependencies: ["ConCurrencyBot"]),
    ]
)
