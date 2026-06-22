# ``ChordProviderGUI``

@Metadata {
    @DisplayName("Chord Provider GUI")
    @PageImage(purpose: card, source: card-gui, alt: Icon)
}

A **ChordPro** viewer and editor for Linux

## Overview

### ChordPro

[ChordPro](https://www.chordpro.org) is an open standard text format for songs with chords and lyrics.

It also has an [official reference implementation](https://www.chordpro.org/chordpro/chordpro-directives/).

**Chord Provider** is my hobby project, written mainly for my own needs as a musician and programmer.

### Chord Provider

**Chord Provider** is written in Swift and uses [Adwaita for Swift](https://git.aparoksha.dev/aparoksha/adwaita-swift) for the GUI.

![Chord Provider](https://github.com/Desbeers/Chord-Provider/raw/main/Images/screenshot-adwaita-2.png)

There are many ChordPro parsers and editors available, but very few feel truly native on Linux desktops. That is what I wanted to build.

The application started as a macOS SwiftUI project, but was later rewritten for Linux with a native GNOME interface.

### The icon

Of course it is based on a **Telecaster**.

In 2016 I fell in love with an *Olympic White* Telecaster. The icon shape and colors are inspired by that guitar.

![Chord Provider icon](icon.png)

### Building

The recommended way to build **Chord Provider** is as a Flatpak application.

Clone the repository and build it with [GNOME Builder](https://apps.gnome.org/en-GB/Builder/).

## A note about Swift

I originally started learning Swift for macOS development and stayed with the language because I genuinely enjoy using it.

I moved away from Apple platforms, but kept using Swift. The language itself was never really the problem.

And yes, my very first Swift course used Taylor Swift songs in many code examples, so that is how I accidentally learned about Taylor Swift and became a *real* Swifty :-D

## Topics

### Basics

@Links(visualStyle: detailedGrid) {
   - <doc:ChordProviderFeatures>
}

### Adwaita Views

- ``ChordProvider``
- ``Views``
- ``Widgets``
- ``GtkRender``

### Application State

- ``AppState``
- ``DatabaseState``
- ``AppSettings``
- ``RecentSongs``
