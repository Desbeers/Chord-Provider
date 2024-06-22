CURRDATE := $(shell date "+%Y-%m-%d")
TESTBUILDDIR := TestBuild
DMGNAME :=  Chord Provider macOS ${CURRDATE}.dmg
MKDIR := mkdir

DEST   := build

all: archive

xcodebuild:
	@echo "Building Chord Provider"
	rm -fr "${DEST}"
	$(MKDIR) -p "${DEST}"
	xcodebuild \
		-scheme BaseMacApp \
		-configuration Release \
		-arch x86_64 \
		CODE_SIGN_IDENTITY="" \
		CODE_SIGNING_REQUIRED=NO \
		-derivedDataPath "${DEST}"
		
archive: xcodebuild
	@echo "Archive Chord Provider"
	$(MKDIR) -p "${DEST}/Chord Provider"
	cp -r "${DEST}/Build/Products/Release/Chord Provider.app" "${DEST}/Chord Provider"
	rm -f "${DEST}/${DMGNAME}"
	hdiutil create -format UDZO -srcfolder "${DEST}/Chord Provider" "${DEST}/${DMGNAME}"
	
clean:
	rm -fr ${DEST}