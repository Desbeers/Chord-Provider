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

Written in SwiftUI for macOS Ventura, iPadOS 16 and visionOS

### General

- It wil view and/or edit 'ChordPro' files.
- It recognise most of the 'ChordPro' directives, but not all.
- It has a 'highlighted TextEditor'.
- It can transpose a song; however, only in the View. The document will not be changed and that's on purpose.
- You can 'define' a Capo but that will not change any notes; again on purpose.
- You can click on a chord diagram and it will open a Sheet with all known versions.
- It can export your song to a PDF document.
- It can play chords with MIDI. Note: This does not work in a simulator.
- It can play songs when stored next to the ChordPro file.


### macOS

- It has a 'browser' for your songs if you select a folder.
- It has a 'quick view' plugin for 'ChordPro' files.

## viosionOS

- It breaks with every update.
- It is the future; however, not yet.
  
### Limitations

Well, Chord Provider a simple application. There are a lot better 'chord' applications and I wrote this just for fun. It serves me well but I know it's not that great. It might serve you well, as a 'chord' program or as a sample for a 'document based SwiftUI' application. SwiftUI is fun and great, however, also limited and challenging; especially on macOS. There are many 'workarounds' in the code; especially for 'window handling'.

Not all chords in the database are correct; especially the more complicated chords. I wrote [Chords Database](https://github.com/Desbeers/Chords-Database) for macOS Ventura to view and alter the database with all known chords.

### iCloud

The iOS app will make an iCloud folder named "Chord Provider"; that's where your songs should be stored. In the macOS app, you can select a folder with your songs. If you use the same iCloud folder; updates are instantly.

### Known issues

- When you switch from light to dark mode and visa-versa; the chord diagrams are not updated.
- SwiftUI 'DocumentGroup', used to show the songs, is very buggy and limited.
- 'Pinch to zoom' is buggy on macOS. Sometimes it just stops working. There is a 'zoom' slider in the toolbar.
- The 'song' is rendered in a SwiftUI View, so, a bit sluggish... But fancy!

### Thanks

Stole code (and ideas) from:

- [SongPro for Swift](https://github.com/SongProOrg/songpro-swift)
- [Conscriptor](https://github.com/dbarsamian/conscriptor)

### Used packages

The chord diagrams are made with [Swifty Guitar Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords).
The editor is [HighlightedTextEditor](https://github.com/kyle-n/HighlightedTextEditor)
The onboarding for iPadOS is thanks to [DocumentKit](https://github.com/danielsaidi/DocumentKit)

I use my [SwiftlyChordUtilities](https://github.com/Desbeers/SwiftlyChordUtilities) package for chord handling.

I use my [SwiftlyFolderUtilities](https://github.com/Desbeers/SwiftlyFolderUtilities) package to handle folder selection and monitoring.

## How to compile

Xcode 15 is required.

1. Clone the project.
2. Change the signing certificate to your own.
2. Build and run!
