# ``GoDuration``

Parse a duration written in Go syntax into seconds for use with Foundation APIs.

## Parse a duration

``GoDuration/parse(_:)`` accepts one or more decimal number and unit pairs. Prefix
the complete duration with `+` or `-` to choose its sign.

```swift
let timeout = try GoDuration.parse("1h30m")
let offset = try GoDuration.parse("-250ms")
```

The supported units are `ns`, `us`, `µs`, `μs`, `ms`, `s`, `m`, and `h`. The
special string `0` represents zero seconds without a unit. Leading and trailing
characters in Foundation's `.whitespaces` set, such as spaces and tabs, are ignored.
Line breaks and whitespace between components are not accepted.

Malformed input throws ``GoDurationError``. Its associated values identify the
unsupported single-character unit, the parsed number missing a unit, or the character
offset where numeric scanning stopped. ``GoDurationError/invalidType(_:)`` can record an
unsupported runtime type, but ``GoDuration/parse(_:)`` cannot produce it because Swift
requires a `String` argument.

## Topics

### Parsing

- ``GoDuration/parse(_:)``
- ``GoDurationError``
