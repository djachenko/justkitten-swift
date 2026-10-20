// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "JustKitten",
    platforms: [.iOS(.v18), .macOS(.v14)],
    products: [
        .library(name: "JustKitten", targets: ["JustKitten"]),
        .library(name: "JustKittenDI", targets: ["JustKittenDI"]),
        .library(name: "ParaMap", targets: ["ParaMap"])
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject", from: "2.10.0"),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration", from: "2.9.1")
    ],
    targets: [
        .target(name: "JustKitten"),
        .target(name: "ParaMap", dependencies: ["Swinject"]),
        .target(name: "JustKittenDI", dependencies: ["JustKitten", "Swinject", "SwinjectAutoregistration"]),
        .testTarget(name: "JustKittenTests", dependencies: ["JustKitten"]),
        .testTarget(name: "ParaMapTests", dependencies: ["ParaMap"]),
        .testTarget(name: "JustKittenDITests", dependencies: ["JustKittenDI"])
    ]
)
