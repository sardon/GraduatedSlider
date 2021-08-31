// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraduatedSlider",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "GraduatedSlider",
            targets: ["GraduatedSlider"]),
    ],
    dependencies: [

    ],
    targets: [

        .target(
            name: "GraduatedSlider",
            dependencies: [])
    ],
    swiftLanguageVersions: [.v5]
)
