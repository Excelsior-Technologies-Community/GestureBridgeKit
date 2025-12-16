// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GestureBridgeKit",
    
    platforms: [
        .iOS(.v14)
    ],
    
    products: [
        .library(
            name: "GestureBridgeKit",
            targets: ["GestureBridgeKit"]
        )
    ],
    
    targets: [
        .target(
            name: "GestureBridgeKit",
            path: "Sources/GestureBridgeKit"
        )
    ]
)
