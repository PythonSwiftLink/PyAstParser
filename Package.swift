// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PyAstParser",
    platforms: [
		.macOS(.v11),
		.iOS(.v13)
	],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PyAstParser",
            targets: ["PyAstParser"]),
//		.library(
//			name: "PyAstBuilder",
//			type: .static,
//			targets: ["PyAstBuilder"]
//		)
    ],
    dependencies: [
      
        //.package(path: "../PythonSwiftLink"),
		//.package(url: "https://github.com/PythonSwiftLink/PythonLib", from: "0.1.0"),
		.package(url: "https://github.com/PythonSwiftLink/PythonSwiftLink",from: .init(0, 0, 0)),
		.package(url: "https://github.com/apple/swift-syntax", from: .init(508, 0, 0)),
		//.package(url: "https://github.com/PythonSwiftLink/PythonTestSuite", branch: "master")
		//.package(path: "../PythonTestSuite")

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PyAstParser",
            dependencies: [
				.product(name: "PythonSwiftCore", package: "PythonSwiftLink"),
				//.product(name: "SwiftSyntax", package: "swift-syntax"),
			]),
		.target(
			name: "PyAstBuilder",
			dependencies: [
				//.product(name: "SwiftSyntax"),
				.product(name: "SwiftSyntax", package: "swift-syntax"),
				.product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
				.product(name: "PythonSwiftCore", package: "PythonSwiftLink"),
				"PyAstParser",
				//"swift-syntax"
				//.product(name: "SwiftSyntax", package: "SwiftParser")
			]),
//        .testTarget(
//            name: "PyAstParserTests",
//            dependencies: [
//				"PyAstParser",
//				"PyAstBuilder",
//				"PythonTestSuite"
//			]),
    ]
)
