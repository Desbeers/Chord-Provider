# Chord Provider

## A [ChordPro](https://www.chordpro.org) viewer, editor and PDF exporter for macOS

![Icon](https://github.com/Desbeers/Chord-Provider/raw/main/Images/icon.png)

## ChordPro

**ChordPro** is an open standard text format and its has an [official reference implementation](https://www.chordpro.org/chordpro/chordpro-directives/). While I hope you like **Chord Provider**, as *guitar player* or *macOS programmer*, it is just my hobby project.

## Chord Provider

**Chord Provider** is written in Swift 6 and SwiftUI and needs macOS Sequoia or macOS Tahoe.

![Chord Provider](https://github.com/Desbeers/Chord-Provider/raw/main/Images/screenshot-macOS.jpg)

There are many [ChordPro](https://www.chordpro.org) parsers in this world, however, almost none are *really* native in the *macOS* world, it is often an afterthought... Not for me. I'm *Mac* user only and I don't use *iStuff*.

### The icon

A **Telecaster** shape, of course! In mid 2016, I felt in love with a guitar. An *Olympic White*. That is the color of the shape. The background is a suitable modification of her 'plate'.

On macOS *Tahoe*, the application icon is not allowed to go out of its squarish boundary anymore; another lost of macOS identity... Now it has its own ugly *glass* icon, sorry for that...

### What can **Chord Provider** do?

- It will view your **ChordPro** files.
- It can export your song as a PDF document or a whole folder with **ChordPro** songs to a PDF with a *Table of Contents*
- It has a fancy editor to edit your songs
- It can play the chords with MIDI with a guitar instrument that you can select in the `settings`
- It can play audio songs or videos when stored next to the **ChordPro** file
- It has a *database* with a lot of chords.
- *left-handed* chords support

### Optional use the **ChordPro CLI reference implementation** for PDF creation

The [official reference implementation](https://www.chordpro.org/) of the **ChordPro** format is *much* more powerful to create PDF's.

If you have the CLI utility installed on your system, **Chord Provider** can optional use it for creating PDF's.

## A *true* macOS application

- It has a *quicklook* plugin for **ChordPro** files. Select a song in the *Finder* and press `space`.
- It makes *thumbnails* for your **ChordPro** files with the **Chord Provider** icon and the name on the song below. True eye candy!

Besides that; its an interesting project for *macOS* programmers. It renders PDF's; use the `ViewThatFits` magic to show a song in columns, playing MIDI with *CoreAudio* and deals with the `DocumentGroup` beast...

It's editor is written from scratch; in `AppKit`.

While I studied a lot of code from other projects to learn; in the end, its all included. I don't like dependencies!

## Binaries

I like `Swift` and `SwiftUI` but I don’t like the more and more lockdown of my beloved *macOS*. I don’t have a `Developer` account but that should't be needed to bring an *Open Source* applications to the Mac.

> Apple loved *Open Source* when it needed it. Not anymore.

I have no intension to bring **Chord Provider** to the Apple Store but I also can't provide an *easy* compiled binary here on GitHub because it is not notarised and signed by the almighty gatekeeper. The provided *release* is only *ad-hoc* signed.

Well, the source is free!

> *Open Source* software projects should get a free account.

Please read the **Read me First**.
  
## Limitations

Some other guitar applications claim the *ownership* of **ChordPro** files and then the *quicklook* does not work anymore. **Chord Provider** does not own them; nobody should...

Not all chords in the database are correct; especially the more complicated chords. Feel free to contribute!

It is not a complete implementation of the **ChordPro** standard. Again, this is my *hobby project* for my own needs. The [official ChordPro implementation](https://www.chordpro.org/) might serve you better. I contributed a lot to its [Open Source code](https://github.com/ChordPro/chordpro).

## Thanks

Stole code (and ideas) from:
- [Swifty Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords)
- [SongPro for Swift](https://github.com/SongProOrg/songpro-swift)
- [Conscriptor](https://github.com/dbarsamian/conscriptor)
- [PdfBuilder](https://github.com/atrbx5/PdfBuilder)
- [HighlightedTextEditor](https://github.com/kyle-n/HighlightedTextEditor)
- [LNTextView](https://github.com/JonWorms/LNTextView)

Learned a lot from Swift mailing lists:
- [Fatbobman](https://fatbobman.com/en/)
- [SwiftLee](https://www.avanderlee.com)
- [Swift with Majid](https://swiftwithmajid.com)

I hope you learn something from my project as well!

## AI

None of my code is generated by AI. AI is *stealing* in my opinion. Programming is *art*.

## How to compile

Xcode 26 is required.

1. Clone the project.
2. Change the signing certificate to your own.
2. Build and run!

**Chord Provider** does not use any external packages.
