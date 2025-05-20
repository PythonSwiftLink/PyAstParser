// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PyAstParser",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "PyAstParser",
            targets: ["PyAstParser"]
        ),
    ],
    dependencies: [
        //.package(path: "../PyAst"),
        //.package(path: "../PyCodable"),
        //.package(path: "../PySwiftWrapper"),
        .package(url:  "https://github.com/PythonSwiftLink/PyAst", from: .init(0, 0, 0)),
        .package(url:  "https://github.com/PythonSwiftLink/PySwiftWrapper", from: .init(0, 0, 0)),
        .package(url: "https://github.com/PythonSwiftLink/PyCodable", from: .init(0, 0, 0)),
        .package(url:  "https://github.com/PythonSwiftLink/PySwiftKit", from: .init(311, 0, 0)),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0"),
        .package(url: "https://github.com/kylef/PathKit", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: .init(1, 2, 0)),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "PyAstParser",
            dependencies: [
                "PyAst",
                .product(name: "SwiftonizeModules", package: "PySwiftKit"),
                "PyCodable",
                "PathKit",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "PySwiftWrapper"
            ]
        ),

    ]
)
