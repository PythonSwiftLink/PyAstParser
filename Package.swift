// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PyAstParser",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PyAstParser",
            targets: ["PyAstParser"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        //.package(path: "../PythonSwiftCore"),
        //.package(url: "https://github.com/PythonSwiftLink/PythonSwiftCore", branch: "testing"),
        .package(url: "https://github.com/PythonSwiftLink/PythonSwiftCore", exact: .init(0, 2, 0))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PyAstParser",
            dependencies: ["PythonSwiftCore"]),
        .testTarget(
            name: "PyAstParserTests",
            dependencies: ["PyAstParser"]),
    ]
)
