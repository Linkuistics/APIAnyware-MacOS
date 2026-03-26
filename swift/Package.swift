// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "APIAnywareMacOS",
    platforms: [.macOS(.v14)],
    products: [
        // Each language dylib statically embeds APIAnywareCommon, producing a single
        // self-contained .dylib per language (no separate libAPIAnywareCommon.dylib needed).
        .library(name: "APIAnywareRacket", type: .dynamic, targets: ["APIAnywareRacket"]),
        .library(name: "APIAnywareChez", type: .dynamic, targets: ["APIAnywareChez"]),
        .library(name: "APIAnywareGerbil", type: .dynamic, targets: ["APIAnywareGerbil"]),
    ],
    targets: [
        .target(name: "APIAnywareCommon"),
        .target(name: "APIAnywareRacket", dependencies: ["APIAnywareCommon"]),
        .target(name: "APIAnywareChez", dependencies: ["APIAnywareCommon"]),
        .target(name: "APIAnywareGerbil", dependencies: ["APIAnywareCommon"]),
        .testTarget(name: "APIAnywareCommonTests", dependencies: ["APIAnywareCommon"]),
        .testTarget(name: "APIAnywareRacketTests", dependencies: ["APIAnywareRacket"]),
    ]
)
