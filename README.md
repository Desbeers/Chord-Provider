# Chord Provider

## A Cordpro file parser and editor in SwiftUI 2.0

There are many "chordpo" parsers in this world, however, none are *really* native in the Apple world. I mean, the macOS world, it is afterthought... Not for me.

![Chord Provider](Screenshots/screenshots.png)

This is for macOS and iOS. Written in SwiftUI 2.0, so Big Sur or iOS 14 only.

- System colors
- System fonts
- Dark screen support

### iCloud

The iOS app makes an iCloud folder named "Chord Provider"; that's where your songs should be stored. In the macOS app, you can select a folder with your songs. If you use the same iCloud folder; updates are instantly.

### Known issues

#### macOS

- The app is sandboxed and only works well when living in the Applications folder. If you build it in Xcode and run it from the build folder, the sidebar doesn't work.
- If you have more than one tab open, the list of songs is not refreshed in "background-tabs" when you select a new folder.
- The list of songs are not really parsed; it only looks at the filename. My songs are named 'artist - song.pro'.
- It only lists files with the '.pro' extension.
- Depending on your General System Preference, if you click on a song in the sidebar it will open in a new window or a new tab. I don't know how to 'force' one behaviour and maybe I shouldn't do that anyway.
- If you change color-scheme; the chord diagrams are not updated. They will be correct again after a restart of the app.

#### iOS

- Hand-off is not working. It tries to 'hand-off' to macOS, however, if you click on the icon, a new song is opened.

### Thanks

Stole code (and ideas) from:

[songpro-swift](https://github.com/SongProOrg/songpro-swift)

[ChordsJS](https://github.com/AlexSchwabauer/ChordJS)

The database with the chords came from [Swifty Guitar Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords)
