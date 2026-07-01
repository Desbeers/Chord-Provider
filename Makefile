#####################################################
#                                                   #
# Chord Provider Makefile                           #
#                                                   #
#####################################################

ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

all: run

#####################################################
#                                                   #
# Chord Provider CLI                                #
#                                                   #
#####################################################

cli:
	@echo "Build CLI"
	@swift build \
		--quiet \
		--package-path=ChordProviderCLI
	@cp ./ChordProviderCLI/.build/debug/ChordProviderCLI ./ChordProviderCLI/.build/debug/chordprovider
	@echo "CLI build done"

#####################################################
#                                                   #
# Chord Provider Gnome                              #
#                                                   #
#####################################################

gui: editorsnippets
	@echo "Build GUI"
	@swift build \
		--quiet \
		--package-path=ChordProviderGnome
	@echo "GUI build done"
run: gui
	@echo "Run GUI"
	@$(ROOT_DIR)/ChordProviderGnome/.build/debug/ChordProviderGnome
	@echo "GUI stopped"

#####################################################
#                                                   #
# Chord Provider Editor Snippets                    #
#                                                   #
#####################################################

editorsnippets:
	@echo "Build GenerateSnippets"
	swift build --package-path ChordProviderEditor --product GenerateSnippets
	@$(ROOT_DIR)/ChordProviderEditor/.build/debug/GenerateSnippets
	@echo "Generated Snippets"

#####################################################
#                                                   #
# Chord Provider Documentation                      #
#                                                   #
#####################################################

docs: docsnippets mergedocs docconvert
	@echo "Documentation created"

#####################################################
#                                                   #
# Chord Provider Doc Convert                        #
#                                                   #
#####################################################

docconvert:
	@echo "Convert documentation"
	@docc convert "./Resources/GenerateDocs/Documentation.docc" \
		--hosting-base-path chord-provider \
		--source-service github \
		--checkout-path $(ROOT_DIR) \
		--source-service-base-url https://github.com/Desbeers/Chord-Provider/blob/main \
		--experimental-enable-custom-templates \
		--fallback-display-name ChordProvider \
		--fallback-bundle-identifier nl.desbeers.chordprovider \
		--fallback-bundle-version 1 \
		--output-dir ./Documentation/chord-provider \
		--additional-symbol-graph-dir .build/aarch64-unknown-linux-gnu/extracted-symbols/
	@cp ./Resources/favicon.svg ./Documentation/chord-provider/favicon.svg
	@cp ./Resources/favicon.ico ./Documentation/chord-provider/favicon.ico
	@cp ./Resources/redirect.html ./Documentation/index.html
	@cp ./Resources/redirect.html ./Documentation/chord-provider/index.html
	@cp ./Resources/redirect.html ./Documentation/chord-provider/documentation/index.html
	@echo "Documentation converted"

#####################################################
#                                                   #
# Chord Provider Doc Snippets                       #
#                                                   #
#####################################################

docsnippets:
	@echo "Build GenerateDocSnippets"
	@swift build \
		--quiet \
		--product GenerateDocSnippets
	@$(ROOT_DIR)/.build/debug/GenerateDocSnippets
	@echo "Generated Documentation Snippets"

#####################################################
#                                                   #
# Chord Provider Doc Merge                          #
#                                                   #
#####################################################

mergedocs:
	@echo "Merge package targets"
	@swift package \
		--quiet \
		--allow-writing-to-directory ./Documentation \
		generate-documentation \
		--symbol-graph-minimum-access-level internal \
		--experimental-skip-synthesized-symbols \
		--enable-experimental-combined-documentation \
		--target ChordProviderCore \
		--target ChordProviderGnome \
		--target ChordProviderEditor \
		--target ChordProviderMIDI \
		--target ChordProviderCLI \
		--disable-indexing \
		--output-path ./Documentation
	@rm -Rf ./Documentation/*
	@echo "Package targets merged"

#####################################################
#                                                   #
# Doc Server                                        #
#                                                   #
#####################################################

docserver:
	@python -m http.server -d ./Documentation

#####################################################
#                                                   #
# Linting                                           #
#                                                   #
#####################################################

lint:
	@echo "Linting..."
	@swiftlint lint --quiet --config ./Resources/swiftlint.yaml ./ChordProviderCore/Sources/
	@swiftlint lint --quiet --config ./Resources/swiftlint.yaml ./ChordProviderGnome/Sources/
	@swiftlint lint --quiet --config ./Resources/swiftlint.yaml ./ChordProviderEditor/Sources/
	@swiftlint lint --quiet --config ./Resources/swiftlint.yaml ./ChordProviderMIDI/Sources/
	@swiftlint lint --quiet --config ./Resources/swiftlint.yaml ./ChordProviderCLI/Sources/
	@echo "Linting done."
