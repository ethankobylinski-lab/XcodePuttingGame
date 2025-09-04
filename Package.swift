// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PuttingGameCore",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "PuttingGameCore", targets: ["PuttingGameCore"])
    ],
    targets: [
        .target(name: "PuttingGameCore", path: "Sources/PuttingGameCore"),
        .testTarget(name: "PuttingGameCoreTests", dependencies: ["PuttingGameCore"], path: "Tests/PuttingGameCoreTests")
    ]
)
