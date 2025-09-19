# goduration-swift

Go-style duration parsing for Swift.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/botforge-pro/goduration-swift", from: "1.0.0")
]
```

## Usage

```swift
import GoDuration

let duration1 = try parse("1m")        // 60 seconds
let duration2 = try parse("2h")        // 7200 seconds  
let duration3 = try parse("2h30m")     // 9000 seconds
let duration4 = try parse("-8h")       // -28800 seconds
```