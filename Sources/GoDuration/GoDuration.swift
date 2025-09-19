import Foundation

public enum GoDurationError: Error {
    case invalidType(String)
    case emptyDurationString
    case expectedNumber(Int)
    case missingUnit(Double)
    case invalidUnit(String)
}

public enum GoDuration {
    public static func parse(_ durationString: String) throws -> TimeInterval {
    let s = durationString.trimmingCharacters(in: .whitespaces)
    
    if s.isEmpty {
        throw GoDurationError.emptyDurationString
    }
    
    // Special case for "0"
    if s == "0" {
        return 0
    }
    
    let isNegative = s.hasPrefix("-")
    let isPositive = s.hasPrefix("+")
    let workingString = (isNegative || isPositive) ? String(s.dropFirst()) : s
    
    var totalMinutes: Double = 0
    var i = workingString.startIndex
    
    while i < workingString.endIndex {
        // Parse number (including fractional)
        let numStart = i
        while i < workingString.endIndex && (workingString[i].isNumber || workingString[i] == ".") {
            i = workingString.index(after: i)
        }
        
        if i == numStart {
            let position = workingString.distance(from: workingString.startIndex, to: i)
            throw GoDurationError.expectedNumber(position)
        }
        
        guard let num = Double(String(workingString[numStart..<i])) else {
            let position = workingString.distance(from: workingString.startIndex, to: i)
            throw GoDurationError.expectedNumber(position)
        }
        
        // Parse unit (1-2 chars)
        if i >= workingString.endIndex {
            throw GoDurationError.missingUnit(num)
        }
        
        let unit: String
        let nextIndex = workingString.index(after: i)
        
        if nextIndex < workingString.endIndex {
            let twoCharUnit = String(workingString[i..<workingString.index(after: nextIndex)])
            if ["ns", "us", "µs", "μs", "ms"].contains(twoCharUnit) {
                unit = twoCharUnit
                i = workingString.index(after: nextIndex)
            } else {
                unit = String(workingString[i])
                i = nextIndex
            }
        } else {
            unit = String(workingString[i])
            i = nextIndex
        }
        
        // Convert to minutes
        switch unit {
        case "ns":
            totalMinutes += num / (1000 * 1000 * 1000 * 60)
        case "us", "µs", "μs":
            totalMinutes += num / (1000 * 1000 * 60)
        case "ms":
            totalMinutes += num / (1000 * 60)
        case "s":
            totalMinutes += num / 60
        case "m":
            totalMinutes += num
        case "h":
            totalMinutes += num * 60
        default:
            throw GoDurationError.invalidUnit(unit)
        }
    }
    
    if isNegative {
        totalMinutes = -totalMinutes
    }
    
    return totalMinutes * 60 // Convert minutes to seconds for TimeInterval
    }
}