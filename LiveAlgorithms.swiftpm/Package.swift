// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "LiveAlgorithms",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "LiveAlgorithms",
            targets: ["AppModule"],
            bundleIdentifier: "com.matheussmoreira.LiveAlgorithms",
            teamIdentifier: "P27VQVDFNQ",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .asset("AccentColor"),
            supportedDeviceFamilies: [
                .pad,
            ],
            supportedInterfaceOrientations: [
                .portrait
            ],
            appCategory: .education
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)
