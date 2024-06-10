// swift-tools-version: 5.10

import PackageDescription

let embeddedSwiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("Embedded"),
    .interoperabilityMode(.Cxx),
    .unsafeFlags([
        "-wmo", "-disable-cmo",
        "-Xfrontend", "-gnone",
        "-Xfrontend", "-disable-stack-protector",
        "-Xfrontend", "-emit-empty-object-file"
    ])
]

let embeddedCSettings: [CSetting] = [
    .unsafeFlags(["-fdeclspec"])
]

let linkerSettings: [LinkerSetting] = [
    .unsafeFlags([
        "-Xclang-linker", "-nostdlib",
        "-Xlinker", "--no-entry"
    ])
]

let libcSettings: [CSetting] = [
    .define("LACKS_TIME_H"),
    .define("LACKS_SYS_TYPES_H"),
    .define("LACKS_STDLIB_H"),
    .define("LACKS_STRING_H"),
    .define("LACKS_SYS_MMAN_H"),
    .define("LACKS_FCNTL_H"),
    .define("NO_MALLOC_STATS", to: "1"),
    .define("__wasilibc_unmodified_upstream"),
]

let package = Package(
    name: "EmbeddedFoundation",
    products: [
        .library(
            name: "Foundation",
            targets: [
                "Foundation"
            ]
        ),
    ],
    targets: [
        .target(
            name: "Foundation",
            dependencies: [
                "_CFoundation"
            ],
            cSettings: embeddedCSettings,
            swiftSettings: embeddedSwiftSettings,
            linkerSettings: linkerSettings
        ),
        .target(
            name: "_CFoundation",
            dependencies: [
                "dlmalloc"
            ],
            cSettings: libcSettings
        ),
        .target(
            name: "dlmalloc",
            cSettings: libcSettings
        ),
        .testTarget(
            name: "FoundationTests",
            dependencies: ["Foundation"]),
    ]
)
