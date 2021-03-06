// swift-tools-version:4.0

/*
   Copyright 2017 Ryuichi Laboratories and the Yanagiba project contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import PackageDescription

let package = Package(
  name: "swift-transform",
  products: [
    .executable(
      name: "swift-transform",
      targets: [
        "swift-transform",
      ]
    ),
    .library(
      name: "SwiftTransform",
      targets: [
        "Transform",
      ]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/yanagiba/swift-ast",
      .revision("e9657500e90aebc5220401d222a4664f6241f3d7")
    ),
    .package(
      url: "https://github.com/yanagiba/bocho",
      .exact("0.1.1")
    ),
  ],
  targets: [
    .target(
      name: "Transform",
      dependencies: [
        "SwiftAST+Tooling",
      ]
    ),
    .target(
      name: "swift-transform",
      dependencies: [
        "Transform",
        "Bocho",
      ]
    ),

    // MARK: Tests

    .testTarget(
      name: "CrithagraTests"
    ),
    .testTarget(
      name: "TransformTests",
      dependencies: [
        "Transform",
      ]
    ),
    .testTarget(
      name: "GeneratorTests",
      dependencies: [
        "Transform",
      ]
    ),
  ],
  swiftLanguageVersions: [4]
)
