[![Tests](https://github.com/botforge-pro/goduration-swift/actions/workflows/test.yml/badge.svg)](https://github.com/botforge-pro/goduration-swift/actions/workflows/test.yml)

# goduration-swift

Go-style duration parsing for Swift.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/botforge-pro/goduration-swift", from: "0.1.1")
]
```

## Usage

```swift
import GoDuration

let duration1 = try GoDuration.parse("1m")        // 60 seconds
let duration2 = try GoDuration.parse("2h")        // 7200 seconds  
let duration3 = try GoDuration.parse("2h30m")     // 9000 seconds
let duration4 = try GoDuration.parse("-8h")       // -28800 seconds
```