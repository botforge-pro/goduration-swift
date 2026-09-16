.PHONY: build test docs lint clean

build:
	swift build

test:
	swift test

docs:
	swift package --allow-writing-to-directory .build/docc generate-documentation \
		--target GoDuration --output-path .build/docc \
		--warnings-as-errors \
		--transform-for-static-hosting \
		--hosting-base-path goduration-swift

lint:
	swiftlint

clean:
	swift package clean
