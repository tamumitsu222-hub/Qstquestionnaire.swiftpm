// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Qstquestionnaire",
    platforms: [
        .iOS("18.0")
    ],
    products: [
        .iOSApplication(
            name: "Qstquestionnaire",
            targets: ["Qstquestionnaire"],
            bundleIdentifier: "com.example.Qstquestionnaire",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .abstract),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "Qstquestionnaire",
            path: "Sources"
        )
    ]
)
