import Foundation

/// A reason a duration string could not be parsed.
public enum GoDurationError: Error {
  /// An input value had an unsupported runtime type, named by the associated string.
  ///
  /// ``GoDuration/parse(_:)`` does not produce this case because its input is statically
  /// typed as `String`.
  case invalidType(String)
  /// The string was empty after removing leading and trailing Foundation `.whitespaces`.
  ///
  /// Line breaks are not part of that character set and do not produce this error.
  case emptyDurationString
  /// A number could not be parsed; the character offset is where scanning stopped.
  ///
  /// The offset is measured in Swift `Character` values from the trimmed duration body,
  /// after removing its leading sign. When no numeric characters were present, the
  /// offset is where scanning began.
  case expectedNumber(Int)
  /// The associated parsed number had no following unit.
  case missingUnit(Double)
  /// The associated single-character unit token is not supported.
  case invalidUnit(String)
}

/// Parses duration strings written in Go's duration syntax.
public enum GoDuration {
  /// Reads a Go duration string as a count of seconds.
  ///
  /// A duration contains one or more decimal number and unit pairs, optionally preceded
  /// by `+` or `-`. Supported units are `ns`, `us`, `µs`, `μs`, `ms`, `s`, `m`, and
  /// `h`; the unitless string `0` is also accepted. Leading and trailing characters in
  /// Foundation's `.whitespaces` set are ignored, but line breaks and whitespace between
  /// components are rejected.
  ///
  /// - Parameter durationString: The duration to parse, such as `"1h30m"`, `"-2.5s"`,
  ///   or `"300ms"`.
  /// - Returns: The represented duration in seconds.
  /// - Throws: ``GoDurationError/emptyDurationString`` for an empty trimmed input;
  ///   ``GoDurationError/expectedNumber(_:)`` when a component's number cannot be parsed;
  ///   ``GoDurationError/missingUnit(_:)`` when a number has no unit; or
  ///   ``GoDurationError/invalidUnit(_:)`` for an unsupported unit token.
  public static func parse(_ durationString: String) throws -> TimeInterval {
    let trimmed = durationString.trimmingCharacters(in: .whitespaces)
    if trimmed.isEmpty {
      throw GoDurationError.emptyDurationString
    }
    if trimmed == "0" {
      return 0
    }

    let isNegative = trimmed.hasPrefix("-")
    let hasSign = isNegative || trimmed.hasPrefix("+")
    let body = hasSign ? String(trimmed.dropFirst()) : trimmed

    var totalMinutes: Double = 0
    var cursor = body.startIndex
    while cursor < body.endIndex {
      let amount = try parseNumber(in: body, from: &cursor)
      let unit = try parseUnit(in: body, from: &cursor, after: amount)
      totalMinutes += try minutes(amount, in: unit)
    }
    return (isNegative ? -totalMinutes : totalMinutes) * 60
  }

  private static func parseNumber(in text: String, from cursor: inout String.Index) throws -> Double
  {
    let start = cursor
    while cursor < text.endIndex, text[cursor].isNumber || text[cursor] == "." {
      cursor = text.index(after: cursor)
    }
    let position = text.distance(from: text.startIndex, to: cursor)
    guard cursor != start, let value = Double(String(text[start..<cursor])) else {
      throw GoDurationError.expectedNumber(position)
    }
    return value
  }

  private static func parseUnit(
    in text: String,
    from cursor: inout String.Index,
    after amount: Double
  ) throws -> String {
    guard cursor < text.endIndex else {
      throw GoDurationError.missingUnit(amount)
    }
    let next = text.index(after: cursor)
    if next < text.endIndex {
      let pair = String(text[cursor..<text.index(after: next)])
      if twoCharacterUnits.contains(pair) {
        cursor = text.index(after: next)
        return pair
      }
    }
    let single = String(text[cursor])
    cursor = next
    return single
  }

  private static let twoCharacterUnits: Set<String> = ["ns", "us", "µs", "μs", "ms"]

  private static func minutes(_ amount: Double, in unit: String) throws -> Double {
    switch unit {
    case "ns": return amount / (1000 * 1000 * 1000 * 60)
    case "us", "µs", "μs": return amount / (1000 * 1000 * 60)
    case "ms": return amount / (1000 * 60)
    case "s": return amount / 60
    case "m": return amount
    case "h": return amount * 60
    default: throw GoDurationError.invalidUnit(unit)
    }
  }
}
