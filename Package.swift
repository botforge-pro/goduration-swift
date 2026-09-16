// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "GoDuration",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "GoDuration",
            targets: ["GoDuration"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.3.0")
    ],
    targets: [
        .target(
            name: "GoDuration"
        ),
        .testTarget(
            name: "GoDurationTests",
            dependencies: ["GoDuration"]
        )
    ]
)
