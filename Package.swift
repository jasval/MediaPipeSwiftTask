// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MediaPipeSwiftTask",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "MediaPipeSwiftTask",
            targets: ["MediaPipeSwiftTask"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MediaPipeSwiftTask",
            dependencies: [
                "MediaPipeTasksGenAI",
                "MediaPipeTasksGenAIC"
            ]
        ),
        .binaryTarget(
            name: "MediaPipeTasksGenAI",
            url: "https://github.com/jasval/MediaPipeSwiftTask/releases/download/v1.0.3/MediaPipeTasksGenAI.xcframework.zip",
            checksum: "76b850b0e66554f9c0adf249e41ba2ee1f22fa057e9c0e94c8a98a610e3b9a01"
        ),
        .binaryTarget(
            name: "MediaPipeTasksGenAIC", 
            url: "https://github.com/jasval/MediaPipeSwiftTask/releases/download/v1.0.3/MediaPipeTasksGenAIC.xcframework.zip",
            checksum: "0a639941dbcb4b16f85ca2b1412ed7c97a7c9020fb592095023507ded34fd688"
        )
    ]
)
