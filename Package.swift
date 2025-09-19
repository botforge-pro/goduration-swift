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