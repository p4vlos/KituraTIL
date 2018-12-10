// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    //1 You first set the name of your target executable. By convention, you should name this after the enclosing directory.
    name: "KituraTIL",
    dependencies: [
        //2 Here you declare the dependency for Kitura itself.
        .package(url: "https://github.com/IBM-Swift/Kitura.git",
                 .upToNextMinor(from: "2.4.1")),
        //3 This is a backend logging framework, which you’ll use to log messages while your backend app is running.
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git",
                 .upToNextMinor(from: "1.7.1")),
        //4 You’ll use this dependency to allow Kitura to communicate with CouchDB.
        .package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git",
                 .upToNextMinor(from: "2.1.0")),
    ],
    //5 Finally, you declare your targets and their dependencies.
    targets: [
        .target( name: "KituraTIL",
                 dependencies: ["Kitura", "HeliumLogger", "CouchDB"],
                 path: "Sources")
    ]
)
