import Testing
import Foundation
@testable import GoDuration

struct GoDurationTests {
    @Test(arguments: [
        ("1m", 60),
        ("2h", 7200), 
        ("2h30m", 9000),
        ("-8h", -28800),
        ("1s", 1),
        ("30s", 30),
        ("1m30s", 90),
        ("300ms", 0.3),
        ("1s500ms", 1.5),
        ("500us", 0.0005),
        ("500µs", 0.0005),
        ("1000ns", 0.000001),
        ("1.5h", 5400),
        ("2.5m", 150),
        ("1.25s", 1.25),
        ("1h15m30.918s", 4530.918)
    ])
    func parseValidDurations(input: String, expectedSeconds: Double) throws {
        let result = try GoDuration.parse(input)
        #expect(result == expectedSeconds)
    }
    
    @Test(arguments: [
        "",
        "1", 
        "1x",
        "1m4z",
        "h1",
        "1.2.3m"
    ])
    func parseInvalidDurations(invalidInput: String) throws {
        #expect(throws: GoDurationError.self) {
            try GoDuration.parse(invalidInput)
        }
    }
}