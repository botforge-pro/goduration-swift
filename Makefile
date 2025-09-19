.PHONY: build test lint clean

build:
	swift build

test:
	swift test

lint:
	swiftlint

clean:
	swift package clean