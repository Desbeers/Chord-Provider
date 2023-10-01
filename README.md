# Chord Provider

## A [ChordPro](https://www.chordpro.org) file parser and editor for macOS, iPadOS and visionOS

![Icon](https://github.com/Desbeers/Chord-Provider/raw/main/Images/icon.png)

**Chord Provider** is written in SwiftUI and needs Xcode 15 to compile.

- macOS Ventura
- iPadOS 16
- visionOS 1

There are many "ChordPro" parsers in this world, however, none are *really* native in the Apple world.

I mean, in the macOS world, it is often an afterthought... Not for me. I'm mainly a mac user; the other versions are my afterthought...

![Chord Provider](https://github.com/Desbeers/Chord-Provider/raw/main/Images/screenshot-macOS.jpg)

### The icon

A Telecaster shape, of course! In mid 2016 I felt in love with a guitar. An 'Olympic White'. That is the color of the shape. The background is a suitable modification of her 'plate'.

### General

- It wil view and/or edit **ChordPro** files.
- It recognise most of the **ChordPro** directives, but not all.
- It can show diagrams for the guitar, guitalele and ukulele.
- You can click on a chord diagram and it will open a Sheet with all known versions.
- It can transpose a song; however, only in the View. The document will not be changed and that's on purpose.
- You can 'define' a Capo but that will not change any notes in the document; again on purpose.
- It can export your song to a PDF document.
- It can play chords with MIDI. Note: This does not work in a simulator.
- It can play songs when stored next to the **ChordPro** file.
- Full 'left-handed' support.


### macOS

- It has a 'browser' for your songs if you select a folder.
- It has a 'quick view' plugin for **ChordPro** files.

### visionOS

- Currently `DocumentGroup` is partly broken (Xcode 15 beta 8).
- It is the future; however, not yet.
  
### Limitations

Not all chords in the database are correct; especially the more complicated chords. I wrote [Chords Database](https://github.com/Desbeers/Chords-Database) for macOS and iPadOS to view and alter the database with all known chords. Feel free to contribute!

### iCloud

The iOS app will make an iCloud folder named **Chord Provider**; that's where your songs should be stored. In the macOS app, you can select a folder with your songs. If you use the same iCloud folder; updates are instantly.

### Thanks

Stole code (and ideas) from:
- [Swifty Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords)
- [SongPro for Swift](https://github.com/SongProOrg/songpro-swift)
- [Conscriptor](https://github.com/dbarsamian/conscriptor)

### Used packages

#### External:

- The editor is [HighlightedTextEditor](https://github.com/kyle-n/HighlightedTextEditor)
- The song in *column view* is thanks to [FrameUp](https://github.com/ryanlintott/FrameUp)
- The onboarding for iPadOS is [DocumentKit](https://github.com/danielsaidi/DocumentKit)

#### My own:

![Icon](https://github.com/Desbeers/SwiftlyChordUtilities/raw/main/Images/icon.png)

- [SwiftlyChordUtilities](https://github.com/Desbeers/SwiftlyChordUtilities): Handle musical chords
- [SwiftlyFolderUtilities](https://github.com/Desbeers/SwiftlyFolderUtilities): Handle folder selection and monitoring
- [SwiftlyAlertMessage](https://github.com/Desbeers/SwiftlyAlertMessage): Alerts and confirmation dialogs

*I like to start my package names with **Swiftly** instead of the usual **Swifty** {.leading} or **Kit** {.trailing}.*

*This is simply because it sounds more pleasing to me.*

## How to compile

Xcode 15 is required.

1. Clone the project.
2. Change the signing certificate to your own.
2. Build and run!
