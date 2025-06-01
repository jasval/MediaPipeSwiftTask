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
            url: "https://github.com/jasval/MediaPipeSwiftTask/releases/download/v1.0.0/MediaPipeTasksGenAI.xcframework.zip",
            checksum: "df3a5291db8f692a20755f8da57d0b4ba3c8de0d11d9aaa91ef4c1c437f1ceb1"
        ),
        .binaryTarget(
            name: "MediaPipeTasksGenAIC", 
            url: "https://github.com/jasval/MediaPipeSwiftTask/releases/download/v1.0.0/MediaPipeTasksGenAIC.xcframework.zip",
            checksum: "58dc5812e76e2ff26f94bf1f2ac2fdc981fe7327b2a93b53d810312b9cd25bff"
        )
    ]
)
