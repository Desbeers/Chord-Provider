# Chord Provider

## A [ChordPro](https://www.chordpro.org) viewer, editor and PDF exporter for macOS

![Icon](https://github.com/Desbeers/Chord-Provider/raw/main/Images/icon.png)

**Chord Provider** is written in SwiftUI and needs macOS Sonoma.

There are many **ChordPro** parsers in this world, however, almost none are *really* native in the Apple world.

I mean, in the macOS world, it is often an afterthought... Not for me. I'm mac user only and I don't use iStuff.

SwiftUI is great and fun, however, on the mac... Not always. **Chord Provider** has awful hacks to deal with a SwiftUI `DocumentGroup` Scene For years. While I love my mac, in Cupertino it has not the highest priority...

Also, lockdown goes further and further on macOS. Theoretically for a good reason but in practise a little bit less. I have no intension to bring **Chord Provider** to the Apple Store but I also can't provide a compiled binary here on GitHub because it is not notarised and signed by the almighty gatekeeper. Well, the source is free!

![Chord Provider](https://github.com/Desbeers/Chord-Provider/raw/main/Images/screenshot-macOS.jpg)

### The icon

A Telecaster shape, of course! In mid 2016 I felt in love with a guitar. An 'Olympic White'. That is the color of the shape. The background is a suitable modification of her 'plate'.

### What can **Chord Provider** do?

- It will view and/or edit **ChordPro** files.
- It can export a whole folder with **ChordPro** files to a PDF with a Table of Contents.
- It has an editor that highlights your chords and directives with colors you can change in the settings and you can edit a directive by double-clicking on it.
- It recognise most of the **ChordPro** directives, but not all.
- It can show diagrams for the guitar, guitalele and ukulele.
- You can click on a chord diagram and it will open a Sheet with all known versions.
- It can transpose a song; however, only in the View. The document will not be changed and that's on purpose.
- You can 'define' a Capo but that will not change any notes in the document; again on purpose.
- It can export your song to a PDF document.
- It can play chords with MIDI with a guitar instrument that you can select in the settings. *Note: This does not work in a simulator*.
- It can play audio songs when stored next to the **ChordPro** file when defined with `{musicpath: file-name.m4a}` and when a music folder is selected (sandbox restriction).
- Full 'left-handed' chords support.
- It has a 'Song List' Window for your songs if you select a folder.
- It has a 'quicklook' plugin for **ChordPro** files. Select a song in the `Finder` and press `space`
- It makes thumbnails for your **ChordPro** files.
- It has a fancier editor with linenumbers and you can edit a directive by double-clicking on it.
  
### Limitations

Some other guitar applications claim the *ownership* of **ChordPro** files and then the *quicklook* does not work anymore. **Chord Provider** does not own them; nobody should...

Not all chords in the database are correct; especially the more complicated chords. I wrote [Chords Database](https://github.com/Desbeers/Chords-Database) for macOS and iPadOS to view and alter the database with all known chords. Feel free to contribute!

### Documentation

The source code is very well [documented](https://desbeers.github.io/Chord-Provider/) with [Jazzy](https://github.com/realm/jazzy); including the [SwiftlyChordUtilities](https://github.com/Desbeers/SwiftlyChordUtilities) package that is an essential part of **Chord Provider**.

### `SwiftUI` previews

I don't use it so there a no `#preview` macro for any of my `Views`

### TODO

- Make it translatable; now it is only in English
- Use different chord notations for e.g. German (CDEFGAH)

Both are not high on my list, however a [PR](https://github.com/Desbeers/Chord-Provider/pulls) is welcome!

### Thanks

Stole code (and ideas) from:
- [Swifty Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords)
- [SongPro for Swift](https://github.com/SongProOrg/songpro-swift)
- [Conscriptor](https://github.com/dbarsamian/conscriptor)
- [PdfBuilder](https://github.com/atrbx5/PdfBuilder)
- [HighlightedTextEditor](https://github.com/kyle-n/HighlightedTextEditor)
- [LNTextView](https://github.com/JonWorms/LNTextView)

## How to compile

Xcode 15 is required.

1. Clone the project.
2. Change the signing certificate to your own.
2. Build and run!
