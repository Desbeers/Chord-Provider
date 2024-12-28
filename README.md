# Chord Provider

## A [ChordPro](https://www.chordpro.org) viewer, editor and PDF exporter for macOS

![Icon](https://github.com/Desbeers/Chord-Provider/raw/main/Images/icon.png)

## ChordPro

**ChordPro** is an open standard text format and its has its own [official reference implementation](https://www.chordpro.org/chordpro/chordpro-directives/). I contributed a lot to its [Open Source code](https://github.com/ChordPro/chordpro). While I hope you like **Chord Provider**, as *guitar player* or *macOS programmer*, it is just my hobby project. Go [there](https://chordpro.org) for the full **Chordpro** experience.

## Chord Provider

**Chord Provider** is written in Swift 6 and SwiftUI and needs macOS Sequoia.

![Chord Provider](https://github.com/Desbeers/Chord-Provider/raw/main/Images/screenshot-macOS.jpg)

There are many **ChordPro** parsers in this world, however, almost none are *really* native in the macOS world, it is often an afterthought... Not for me. I'm Mac user only and I don't use iStuff.

### The icon

A Telecaster shape, of course! In mid 2016 I felt in love with a guitar. An 'Olympic White'. That is the color of the shape. The background is a suitable modification of her 'plate'.

### What can **Chord Provider** do?

- It will view and/or edit **ChordPro** files.
- It can export your song to a PDF document.
- It can also export a whole folder with **ChordPro** songs to a PDF with a *Table of Contents*.
- It has an editor that highlights your chords and directives with colours you can change in the settings and you can edit a directive by double-clicking on it.
- It knows most of the **ChordPro** directives, but not all and my implementation is not always according the [official reference implementation](https://www.chordpro.org/chordpro/chordpro-directives/).
- It can show diagrams for the guitar, guitalele and ukulele.
- You can click on a chord diagram and it will open a Sheet with all known versions.
- It can transpose a song; however, only in the View. The document will not be changed and that's on purpose.
- You can 'define' a Capo but that will not change any notes in the document; again on purpose.
- It can play chords with MIDI with a guitar instrument that you can select in the settings.
- It can play audio songs or videos when stored next to the **ChordPro** file,
- Full 'left-handed' chords support.
- It has a 'quicklook' plugin for **ChordPro** files. Select a song in the `Finder` and press `space`. Images are not supported in the preview.
- It makes thumbnails for your **ChordPro** files.

### Optional use the **ChordPro CLI reference implementation** for PDF creation

The [official reference implementation](https://www.chordpro.org/) of the **ChordPro** format is *much* more powerful to create PDF's.

If you have the CLI utility installed on your system, **Chord Provider** can optional use it for creating PDF's.

## Binaries

I like Swift and SwiftUI but I don’t like the more and more lockdown of my beloved macOS. I don’t have a `Developer` account.

Theoretically for a good reason but in practise a little bit less. I have no intension to bring **Chord Provider** to the Apple Store but I also can't provide an *easy* compiled binary here on GitHub because it is not notarised and signed by the almighty gatekeeper.

Well, the source is free!
  
## Limitations

Some other guitar applications claim the *ownership* of **ChordPro** files and then the *quicklook* does not work anymore. **Chord Provider** does not own them; nobody should...

Not all chords in the database are correct; especially the more complicated chords. Feel free to contribute!

It is not a complete implementation of the **ChordPro** standard. Again, this is my *hobby project* for my own needs. The [official ChordPro implementation](https://www.chordpro.org/) might serve you better.

## Thanks

Stole code (and ideas) from:
- [Swifty Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords)
- [SongPro for Swift](https://github.com/SongProOrg/songpro-swift)
- [Conscriptor](https://github.com/dbarsamian/conscriptor)
- [PdfBuilder](https://github.com/atrbx5/PdfBuilder)
- [HighlightedTextEditor](https://github.com/kyle-n/HighlightedTextEditor)
- [LNTextView](https://github.com/JonWorms/LNTextView)

## How to compile

Xcode 16 is required.

1. Clone the project.
2. Change the signing certificate to your own.
2. Build and run!

**Chord Provider** does not use any external packages.
