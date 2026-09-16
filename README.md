[![Tests](https://github.com/botforge-pro/goduration-swift/actions/workflows/test.yml/badge.svg)](https://github.com/botforge-pro/goduration-swift/actions/workflows/test.yml)
[![Documentation](https://github.com/botforge-pro/goduration-swift/actions/workflows/documentation.yml/badge.svg)](https://botforge-pro.github.io/goduration-swift/documentation/goduration/)

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

## Documentation

The [Swift-DocC API reference](https://botforge-pro.github.io/goduration-swift/documentation/goduration/)
is generated from the public API on every push to `main`.

## Lines of Code

<picture>
  <source media="(prefers-color-scheme: dark)" srcset=".github/loc-history-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset=".github/loc-history-light.svg">
  <img src=".github/loc-history.svg" alt="Lines of code over time">
</picture>
