// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "swift-extended",
  platforms: [
    .iOS(.v11),
  ],
  products: [
    .library(
      name: "SwiftExtended",
      targets: ["SwiftExtended"]
    ),
  ],
  targets: [
    .target(
      name: "SwiftExtended",
      dependencies: []
    ),
    .testTarget(
      name: "SwiftExtendedTests",
      dependencies: ["SwiftExtended"]
    ),
  ],
  swiftLanguageVersions: [.v5]
)
