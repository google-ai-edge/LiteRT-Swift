// swift-tools-version: 5.9
// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Manifest of the LiteRT Swift package as published from
// https://github.com/google-ai-edge/LiteRT-Swift.

import PackageDescription

let package = Package(
  name: "LiteRT",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
  ],
  products: [
    .library(
      name: "LiteRT",
      targets: ["LiteRT"]
    ),
    .library(
      name: "LiteRT_static",
      type: .static,
      targets: ["LiteRT"]
    ),
    .library(
      name: "LiteRT_dynamic",
      type: .dynamic,
      targets: ["LiteRT"]
    ),
    .library(
      name: "LiteRtMetalAccelerator",
      targets: ["LiteRtMetalAccelerator"]
    ),
    .library(
      name: "CLiteRT_static",
      targets: ["CLiteRT_static"]
    ),
    .library(
      name: "TensorFlowLite",
      targets: ["TensorFlowLite"]
    ),
  ],
  targets: [
    // The Prebuilt Binary Target
    .binaryTarget(
      name: "CLiteRT",
      url: "https://github.com/google-ai-edge/LiteRT/releases/download/v2.4.0/CLiteRT.xcframework.zip",
      checksum: "71c4e4643f65a307bc3de6a0dcc82bf97576153b2c2c51e693a1623316392b53"
    ),
    .binaryTarget(
      name: "CLiteRT_mac",
      url: "https://github.com/google-ai-edge/LiteRT/releases/download/v2.4.0/CLiteRT_mac.xcframework.zip",
      checksum: "5a5f235fd3ad1477d81a223df50699058773446f46aa06236fdf7ce89f6ecea9"
    ),
    // Static build of the C API for C and Objective-C consumers (iOS only).
    .binaryTarget(
      name: "CLiteRT_static",
      url: "https://github.com/google-ai-edge/LiteRT/releases/download/v2.4.0/CLiteRT_static.xcframework.zip",
      checksum: "cbecf31b0ad32e4bd878d00b46a2a44ffc7aaa1170c79427b14765829477e82a"
    ),
    // Optional GPU Accelerator Plugin Target
    .binaryTarget(
      name: "LiteRtMetalAccelerator",
      url: "https://github.com/google-ai-edge/LiteRT/releases/download/v2.4.0/LiteRtMetalAccelerator.xcframework.zip",
      checksum: "a0a40727df3b48f33dd30029682e23c11a591e5b8b92cd1e740385387468c975"
    ),
    // The Swift Wrapper Target
    .target(
      name: "LiteRT",
      dependencies: [
        .target(name: "CLiteRT", condition: .when(platforms: [.iOS])),
        .target(name: "CLiteRT_mac", condition: .when(platforms: [.macOS])),
      ],
      path: "Sources/LiteRT"
    ),
    // The Prebuilt TensorFlow Lite C Binary Target
    .binaryTarget(
      name: "TensorFlowLiteC",
      url: "https://github.com/google-ai-edge/LiteRT/releases/download/v2.4.0/TensorFlowLiteC.xcframework.zip",
      checksum: "945a2b5d5ef9eea51f3d06d9ebe9087db4c31edcd36195de542465db8039db6a"
    ),
    // The TensorFlow Lite Swift Wrapper Target
    .target(
      name: "TensorFlowLite",
      dependencies: [
        .target(name: "TensorFlowLiteC", condition: .when(platforms: [.iOS])),
      ],
      path: "Sources/TensorFlowLite",
      // The Core ML and Metal delegate C libraries are not shipped in the
      // package, so the delegates that import them are left out.
      exclude: [
        "CoreMLDelegate.swift",
        "MetalDelegate.swift",
      ]
    ),
  ]
)
