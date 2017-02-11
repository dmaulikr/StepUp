import PackageDescription

let package = Package(
    name: "StepUp",
    dependencies: [
        .Package(url: "https://github.com/eelcokoelewijn/FileKit.git", "1.0.1"),
    ]
)
