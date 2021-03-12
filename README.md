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

- It only lists files with the '.pro' extension.
- Hand-off is not working. It tries to 'hand-off' to macOS, however, if you click on the icon, a new song is opened.
- When you switch from light to dark mode and visa-versa; the colors and chord diagrams are not correct.

### Thanks

Stole code (and ideas) from:

[songpro-swift](https://github.com/SongProOrg/songpro-swift)

The chord diagrams are made with [Swifty Guitar Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords)
