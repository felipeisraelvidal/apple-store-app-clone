// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Modules",
            targets: [
                "Core",
                "Shop",
                "ProductDetails",
                "BuyProduct",
                "CustomizeProductOption",
                "Cart",
                "SearchProducts"
            ]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Core",
            dependencies: []),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]),
        .target(
            name: "Networking",
            dependencies: ["Core"]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]),
        .target(
            name: "Shop",
            dependencies: ["Core", "Networking", "SDWebImage"]),
        .testTarget(
            name: "ShopTests",
            dependencies: ["Shop"]),
        .target(
            name: "ProductDetails",
            dependencies: ["Core", "Networking", "SDWebImage"]),
        .testTarget(
            name: "ProductDetailsTests",
            dependencies: ["ProductDetails"]),
        .target(
            name: "BuyProduct",
            dependencies: ["Core", "Networking", "SDWebImage"]),
        .testTarget(
            name: "BuyProductTests",
            dependencies: ["BuyProduct"]),
        .target(
            name: "CustomizeProductOption",
            dependencies: ["Core", "Networking", "SDWebImage"]),
        .testTarget(
            name: "CustomizeProductOptionTests",
            dependencies: ["CustomizeProductOption"]),
        .target(
            name: "SearchProducts",
            dependencies: []),
        .testTarget(
            name: "SearchProductsTests",
            dependencies: ["SearchProducts"]),
        .target(
            name: "Cart",
            dependencies: []),
        .testTarget(
            name: "CartTests",
            dependencies: ["Cart"]),
    ]
)
