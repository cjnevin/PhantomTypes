// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhantomTypes",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PhantomTypes",
            targets: ["PhantomTypes"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "EmptiableTypes", url: "https://github.com/cjnevin/EmptiableTypes", from: "1.0.1"),
        .package(name: "MonoidTypes", url: "https://github.com/cjnevin/MonoidTypes", from: "1.0.1"),
        .package(name: "WrappedTypes", url: "https://github.com/cjnevin/WrappedTypes", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PhantomTypes",
            dependencies: ["EmptiableTypes", "MonoidTypes", "WrappedTypes"]),
        .testTarget(
            name: "PhantomTypesTests",
            dependencies: ["PhantomTypes"]),
    ]
)
