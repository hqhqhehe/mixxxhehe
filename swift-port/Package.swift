// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MixxxSwiftCore",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "MixxxSwiftCore", targets: ["MixxxSwiftCore"])
    ],
    targets: [
        .target(name: "MixxxSwiftCore"),
        .testTarget(
            name: "MixxxSwiftCoreTests",
            dependencies: ["MixxxSwiftCore"]
        )
    ]
)
