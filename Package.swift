import PackageDescription

let package = Package(
    name: "StepUp",
    dependencies: [
        .Package(url: "https://github.com/eelcokoelewijn/FileKit.git", "1.0.2"),
        .Package(url: "https://github.com/eelcokoelewijn/AudioKit.git", "1.0.2"),
        .Package(url: "https://github.com/eelcokoelewijn/CollectionViewKit.git", "1.0.0"),
    ]
)
