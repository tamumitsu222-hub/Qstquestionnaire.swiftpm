// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Qstquestionnaire",
    platforms: [
        .iOS("18.0")
    ],
    targets: [
        .executableTarget(
            name: "Qstquestionnaire",
            path: "Sources"
        )
    ]
)
