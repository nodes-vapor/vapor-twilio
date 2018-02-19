import PackageDescription

let package = Package(
    name: "VaporTwilio",
    dependencies: [
        .Package(url: "https://github.com/harlanhaskins/Punctual.swift.git", majorVersion: 1),
        .Package(url: "https://github.com/nodes-vapor/forms.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/vapor/jwt.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2)
    ]
)

