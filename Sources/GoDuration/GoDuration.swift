import Foundation

public enum GoDurationError: Error {
    case invalidType(String)
    case emptyDurationString
    case expectedNumber(Int)
    case missingUnit(Double)
    case invalidUnit(String)
}

public enum GoDuration {
    /// Reads a Go duration string — `"1h30m"`, `"-2.5s"`, `"300ms"` — as
    /// a count of seconds.
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
            let amount = try number(in: body, from: &cursor)
            let unit = try unitName(in: body, from: &cursor, after: amount)
            totalMinutes += try minutes(amount, in: unit)
        }
        return (isNegative ? -totalMinutes : totalMinutes) * 60
    }

    /// The number every component opens with, digits and one decimal
    /// point. Advances the cursor past it.
    private static func number(in text: String, from cursor: inout String.Index) throws -> Double {
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

    /// The unit after a number. Two characters where the pair names one,
    /// a single character otherwise, so `"ms"` is not read as minutes
    /// followed by seconds.
    private static func unitName(
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

    /// Both micro spellings are here because Go accepts either: the
    /// micro sign and the Greek letter are different characters that
    /// look the same.
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
