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
      url: "https://github.com/google-ai-edge/LiteRT/releases/download/v2.4.1/CLiteRT.xcframework.zip",
      checksum: "e75ec6718f308ee131186f00bcf40d88e9d95d8926f9d9f52fa6edc9d9f43c68"
    ),
    .binaryTarget(
      name: "CLiteRT_mac",
      url: "https://github.com/google-ai-edge/LiteRT/releases/download/v2.4.1/CLiteRT_mac.xcframework.zip",
      checksum: "26a209429985671d3ba2804261e38ce7d3ed83354d87de3b33472c10ca71aea2"
    ),
    // Static build of the C API for C and Objective-C consumers (iOS only).
    .binaryTarget(
      name: "CLiteRT_static",
      url: "https://github.com/google-ai-edge/LiteRT/releases/download/v2.4.1/CLiteRT_static.xcframework.zip",
      checksum: "7f77f3c42aa45b04e00d0e2148e65442c97f75cb07c6227fd47f4e28a850f847"
    ),
    // Optional GPU Accelerator Plugin Target
    .binaryTarget(
      name: "LiteRtMetalAccelerator",
      url: "https://github.com/google-ai-edge/LiteRT/releases/download/v2.4.1/LiteRtMetalAccelerator.xcframework.zip",
      checksum: "eb984375967dac4be077b5d0c008342d8ac987875af71a90d75829738b163ea9"
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
      url: "https://github.com/google-ai-edge/LiteRT/releases/download/v2.4.1/TensorFlowLiteC.xcframework.zip",
      checksum: "1f75af023dd61b29e112df2d0acf1e4c867b84971341849a183d93a9697677eb"
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
