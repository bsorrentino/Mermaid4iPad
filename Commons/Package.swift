// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Commons",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Commons",
            targets: ["Commons"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bsorrentino/SwiftyMonaco.git",  branch: "mermaid"),
        .package(url: "https://github.com/bsorrentino/SwiftyACE.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Commons",
            dependencies: [
                .product(name: "SwiftyMonaco", package: "SwiftyMonaco"),
                .product(name: "SwiftyAceEditor", package: "SwiftyACE")
            ],
            resources: [ /*.copy("keyboard_data.json") */]
            ),
        .testTarget(
            name: "CommonsTests",
            dependencies: ["Commons"]),
    ]
)
