all: run

docs:
	swift package \
		--package-path ChordProviderGnome \
		--allow-writing-to-directory ./Documentation \
		generate-documentation \
		--enable-experimental-combined-documentation \
		--target ChordProviderGUI \
		--target ChordProviderCore \
		--target chordprovider \
		--target ChordProviderMIDI \
		--target SourceView \
		--output-path ./Documentation
	cp Resources/theme-settings.json Documentation/theme-settings.json

run:
	swift run --package-path ChordProviderGnome ChordProviderGUI