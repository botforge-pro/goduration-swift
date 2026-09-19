import Foundation
import Testing

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
    ("500μs", 0.0005),
    ("1000ns", 0.000001),
    ("1.5h", 5400),
    ("2.5m", 150),
    ("1.25s", 1.25),
    ("1h15m30.918s", 4530.918),
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
    "1.2.3m",
  ])
  func parseInvalidDurations(invalidInput: String) throws {
    #expect(throws: GoDurationError.self) {
      try GoDuration.parse(invalidInput)
    }
  }

  @Test("errors preserve the rejected input detail")
  func errorDetails() {
    expectError("", matching: .emptyDurationString)
    expectError("h1", matching: .expectedNumber(0))
    expectError("  -h1  ", matching: .expectedNumber(0))
    expectError("1.2.3m", matching: .expectedNumber(5))
    expectError("1", matching: .missingUnit(1))
    expectError("1xy", matching: .invalidUnit("x"))
  }

  @Test("only surrounding Foundation whitespace is ignored")
  func whitespace() throws {
    #expect(try GoDuration.parse("\t 1m \t") == 60)
    #expect(throws: GoDurationError.self) { try GoDuration.parse("1m 30s") }
    #expect(throws: GoDurationError.self) { try GoDuration.parse("\n1m\n") }
  }

  private func expectError(_ input: String, matching expected: GoDurationError) {
    do {
      _ = try GoDuration.parse(input)
      Issue.record("Expected parsing to fail for \(input)")
    } catch let error as GoDurationError {
      switch (error, expected) {
      case (.emptyDurationString, .emptyDurationString):
        break
      case (.expectedNumber(let actual), .expectedNumber(let expected)) where actual == expected:
        break
      case (.missingUnit(let actual), .missingUnit(let expected)) where actual == expected:
        break
      case (.invalidUnit(let actual), .invalidUnit(let expected)) where actual == expected:
        break
      default:
        Issue.record("Unexpected error \(error) for \(input)")
      }
    } catch {
      Issue.record("Unexpected error type \(error) for \(input)")
    }
  }
}
