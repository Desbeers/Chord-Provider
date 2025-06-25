CURRDATE := $(shell date "+%Y-%m-%d")
VERSION = $(shell cd .. && xcodebuild -showBuildSettings | grep MARKETING_VERSION | tr -d 'MARKETING_VERSION =')
DMGNAME :=  Chord Provider ${VERSION}.dmg
MKDIR := mkdir

DEST   := ../Build

APPDIR := "${DEST}/Chord Provider.app"

all: package
	
clean:
	rm -fr ${DEST}
	
package:
	rm -f "${DEST}/${DMGNAME}"
	bash ../Resources/create-dmg \
		--volname "Chord Provider" \
		--volicon "../Resources/DiskIcon.icns" \
		--window-pos 200 120 \
		--window-size 680 440 \
		--icon-size 64 \
		--icon "Chord Provider.app" 540 125 \
		--hide-extension "Chord Provider.app" \
		--add-file "Read me First.html" "../Resources/README.html"  540 250 \
		--hide-extension "Read me First.html" \
		--background "../Resources/DiskBackground.png" \
		"../Build/${DMGNAME}" ${APPDIR}

remove:
	rm -f "${DEST}/${DMGNAME}"
