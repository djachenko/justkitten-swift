// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "JustKit",
    platforms: [.iOS(.v18), .macOS(.v14)],
    products: [
        .library(name: "JustKit", targets: ["JustKit"]),
        .library(name: "JustKitDI", targets: ["JustKitDI"]),
        .library(name: "ParaMap", targets: ["ParaMap"])
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject", from: "2.10.0")
    ],
    targets: [
        .target(name: "JustKit"),
        .target(name: "ParaMap", dependencies: ["Swinject"]),
        .target(name: "JustKitDI", dependencies: ["JustKit", "Swinject"]),
        .testTarget(name: "JustKitTests", dependencies: ["JustKit"]),
        .testTarget(name: "ParaMapTests", dependencies: ["ParaMap"]),
        .testTarget(name: "JustKitDITests", dependencies: ["JustKitDI"])
    ]
)
