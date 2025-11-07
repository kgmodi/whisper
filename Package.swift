// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhisperMacApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "WhisperMacApp",
            targets: ["WhisperMacApp"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/argmaxinc/WhisperKit.git", from: "0.9.0")
    ],
    targets: [
        .executableTarget(
            name: "WhisperMacApp",
            dependencies: ["WhisperKit"],
            path: "Sources/WhisperMacApp"
        )
    ]
)
