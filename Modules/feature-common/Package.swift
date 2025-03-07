// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-common",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "feature-common",
      targets: ["feature-common"]
    )
  ],
  dependencies: [
    .package(name: "logic-core", path: "./logic-core"),
    .package(name: "logic-business", path: "./logic-business"),
    .package(name: "logic-ui", path: "./logic-ui"),
    .package(name: "logic-api", path: "./logic-api"),
    .package(name: "logic-analytics", path: "./logic-analytics"),
    .package(name: "logic-authentication", path: "./logic-authentication"),
    .package(name: "logic-storage", path: "./logic-storage"),
    .package(name: "feature-test", path: "./feature-test")
  ],
  targets: [
    .target(
      name: "feature-common",
      dependencies: [
        "logic-core",
        "logic-business",
        "logic-ui",
        "logic-api",
        "logic-analytics",
        "logic-storage",
        "logic-authentication"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "feature-common-tests",
      dependencies: [
        "logic-core",
        "feature-common",
        "logic-business",
        "logic-ui",
        "logic-api",
        "logic-analytics",
        "logic-authentication",
        "logic-storage",
        "feature-test"
      ],
      path: "./Tests"
    )
  ]
)
