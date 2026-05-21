# Chord Provider

## A ChordPro viewer and editor for Linux

![Icon](https://github.com/Desbeers/Chord-Provider/raw/main/Images/icon.png)

## ChordPro

[ChordPro](https://www.chordpro.org) is an open standard text format for songs with chords and lyrics.

It also has an [official reference implementation](https://www.chordpro.org/chordpro/chordpro-directives/).

**Chord Provider** is my hobby project, written mainly for my own needs as a musician and programmer.

## Chord Provider

**Chord Provider** is written in Swift and uses [Adwaita for Swift](https://git.aparoksha.dev/aparoksha/adwaita-swift) for the GUI.

![Chord Provider](https://github.com/Desbeers/Chord-Provider/raw/main/Images/screenshot-adwaita-2.png)

There are many ChordPro parsers and editors available, but very few feel truly native on Linux desktops. That is what I wanted to build.

The application started as a macOS SwiftUI project, but was later rewritten for Linux with a native GNOME interface.

### Features

- View and edit **ChordPro** files
- Native Linux GUI with GNOME / libadwaita
- Built-in chord database
- MIDI playback for chords, grids and tabs
- Basic metronome
- Left-handed chord support

## The icon

Of course it is based on a **Telecaster**.

In 2016 I fell in love with an *Olympic White* Telecaster. The icon shape and colors are inspired by that guitar.

## Building

The recommended way to build **Chord Provider** is as a Flatpak application.

Clone the repository and build it with [GNOME Builder](https://apps.gnome.org/en-GB/Builder/).

## macOS

The project originally started as a native macOS SwiftUI application.

The old macOS source code is still available in the repository, but it is no longer maintained and does not compile anymore.

The Linux version is now the primary project.

## Limitations

Not all chords in the database are correct, especially some of the more advanced chords. Contributions are welcome.

This is also not a complete implementation of the full ChordPro standard.

If you need full compatibility, the [official ChordPro implementation](https://www.chordpro.org/) may suit you better.

I also contributed code to the official [ChordPro Open Source project](https://github.com/ChordPro/chordpro).

## Thanks

### Dependencies

- [Adwaita for Swift](https://git.aparoksha.dev/aparoksha/adwaita-swift) for the GUI
- [GTKSourceView](https://gitlab.gnome.org/GNOME/gtksourceview) for the editor
- [FluidSynth](https://github.com/FluidSynth/fluidsynth) for playing MIDI

### Swift resources

I learned a lot from Swift blogs and mailing lists, especially:

- [Fatbobman](https://fatbobman.com/en/)
- [SwiftLee](https://www.avanderlee.com)
- [Swift with Majid](https://swiftwithmajid.com)

Hopefully somebody can learn something from this project as well.

## A note about Swift

I originally started learning Swift for macOS development and stayed with the language because I genuinely enjoy using it.

I moved away from Apple platforms, but kept using Swift. The language itself was never really the problem.

And yes, my very first Swift course used Taylor Swift songs in many code examples, so that is how I accidentally learned about Taylor Swift and became a *real* Swifty :-D
