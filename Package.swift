import PackageDescription

let package = Package(
    name: "StepUp",
    dependencies: [
        .Package(url: "https://github.com/eelcokoelewijn/FileKit.git",
                 versions: Version(1, 0, 0)..<Version(2, 0, 0)),
        .Package(url: "https://github.com/eelcokoelewijn/AudioKit.git",
                 versions: Version(1, 0, 0)..<Version(2, 0, 0)),
        .Package(url: "https://github.com/eelcokoelewijn/CollectionViewKit.git",
                 versions: Version(1, 0, 0)..<Version(2, 0, 0))
    ]
)
