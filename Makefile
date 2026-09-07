#####################################################
#                                                   #
# Chord Provider Makefile                           #
#                                                   #
#####################################################

APP_ID := nl.desbeers.chordprovider

all: run

ARCH := $(shell uname -m)

#####################################################
#                                                   #
# Chord Provider CLI                                #
#                                                   #
#####################################################

cli:
	@echo "Build CLI"
	@swift build \
		--package-path Package \
		--build-path .host \
		--cache-path .cache \
		--product ChordProviderCLI
	@cp .host/debug/ChordProviderCLI .host/debug/chordprovider
	@echo "CLI build done"

#####################################################
#                                                   #
# Chord Provider Gnome                              #
#                                                   #
#####################################################

gui:
	@echo "Build GUI"
	@swift build \
		--package-path Package \
		--build-path .host \
		--cache-path .cache \
		--configuration release \
		--product ChordProviderGnome
	@echo "GUI build done"
run: gui
	@echo "Run GUI"
	@.host/release/ChordProviderGnome
	@echo "GUI stopped"

#####################################################
#                                                   #
# Chord Provider Snippets                           #
#                                                   #
# This only has to run when directives are changed  #
#####################################################

snippets:
	@echo "Build GenerateSnippets"
	@swift build \
		--package-path Package \
		--build-path .host \
		--cache-path .cache \
		--product GenerateSnippets
	@.host/debug/GenerateSnippets
	@echo "Generated Snippets"

#####################################################
#                                                   #
# Chord Provider Documentation                      #
#                                                   #
#####################################################

documentation: mergeDocumentation convertDocumentation
	@echo "Documentation created"

mergeDocumentation:
	@echo "Merge package targets"
	@swift package \
		--package-path Package \
		--build-path .host \
		--allow-writing-to-directory Documentation \
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
	@rm -Rf Documentation/*
	@echo "Package targets merged"

convertDocumentation:
	@echo "Convert documentation"
	@docc convert "Package/ChordProviderDocs/Documentation.docc" \
		--hosting-base-path chord-provider \
		--source-service github \
		--checkout-path . \
		--source-service-base-url https://github.com/Desbeers/Chord-Provider/blob/main \
		--experimental-enable-custom-templates \
		--fallback-display-name ChordProvider \
		--fallback-bundle-identifier $(APP_ID) \
		--fallback-bundle-version 1 \
		--output-dir Documentation/chord-provider \
		--additional-symbol-graph-dir .host/$(ARCH)-unknown-linux-gnu/extracted-symbols/
	@cp Resources/favicon.svg Documentation/chord-provider/favicon.svg
	@cp Resources/favicon.ico Documentation/chord-provider/favicon.ico
	@cp Resources/redirect.html Documentation/index.html
	@cp Resources/redirect.html Documentation/chord-provider/index.html
	@cp Resources/redirect.html Documentation/chord-provider/documentation/index.html
	@echo "Documentation converted"

#####################################################
#                                                   #
# Documentation Server                              #
#                                                   #
#####################################################

documentationServer:
	@python -m http.server -d ./Documentation

#####################################################
#                                                   #
# Linting                                           #
#                                                   #
#####################################################

lint:
	@echo "Linting..."
	@flatpak run \
		--command=/usr/lib/sdk/swift6/bin/swiftlint \
		--filesystem="$(PWD)" \
		--share=network \
		org.gnome.Sdk//50 \
		lint --config ./Resources/swiftlint.yaml ./Package/
	@echo "Linting done."

#####################################################
#                                                   #
# Flatpak                                           #
#                                                   #
#####################################################

FLATPAK_DIR := .flatpak
FLATPAK_STATE := $(FLATPAK_DIR)/state
FLATPAK_BUILD := $(FLATPAK_DIR)/build
FLATPAK_REPO := $(FLATPAK_DIR)/repo
FLATPAK_SWIFT := $(FLATPAK_DIR)/swift
FLATPAK_MANIFEST := $(APP_ID).json
FLATPAK_FILE := $(FLATPAK_DIR)/$(APP_ID).$(ARCH).flatpak

flatpakInstall: swiftResolve
	@echo "Install Flatpak"
	@flatpak-builder \
		--disable-rofiles-fuse \
		--ccache \
		--force-clean \
		--state-dir=$(FLATPAK_STATE) \
		--repo=$(FLATPAK_REPO) \
		--user \
		--install \
		$(FLATPAK_BUILD) \
		$(FLATPAK_MANIFEST)
	@echo "Installing Flatpak done"

flatpakBundle: flatpakInstall
	@echo "Create Flatpak bundle"
	@flatpak \
		build-bundle \
		$(FLATPAK_REPO) \
		$(FLATPAK_FILE) \
		$(APP_ID)
	@echo "Creating Flatpak bundle done"

flatpakRun: flatpakInstall
	@echo "Run Flatpak application"
	@flatpak \
		run $(APP_ID)
	@echo "Stopped running Flatpak application"

swiftResolve:
	@echo "Resolve Swift package in Flatpak SDK"
	@flatpak run \
		--command=/usr/lib/sdk/swift6/bin/swift \
		--filesystem="$(PWD)" \
		--share=network \
		org.gnome.Sdk//50 \
		package resolve \
		--package-path Package \
		--cache-path .cache \
		--build-path .flatpak/swift
	@echo "Swift resolve done"

#####################################################
#                                                   #
# CLEAN                                             #
#                                                   #
#####################################################

clean:
	@echo "Clean project files"
	@rm -f \
		Package.resolved \
		Package/Package.resolved
	@rm -rf \
		.build \
		.flatpak \
		.host \
		Package/.build
