# Chord Provider

@Metadata {
    @TechnologyRoot
    @PageImage(purpose: card, source: icon-app, alt: Icon)
    @PageImage(purpose: icon, source: icon-app, alt: Icon)
}

@Options {
    @TopicsVisualStyle(detailedGrid)
}

A **ChordPro** file parser, viewer and editor for Linux

## Overview

[ChordPro](https://www.chordpro.org) is an open standard text format for songs with chords and lyrics. It also has an [official reference implementation](https://www.chordpro.org/chordpro/chordpro-directives/) that is much more powefull than mine.

**Chord Provider** is my implementation of the *ChordPro* standard. It is written in Swift and uses [Adwaita for Swift](https://git.aparoksha.dev/aparoksha/adwaita-swift) for its GUI.

@TabNavigator {
    @Tab("Main screen") {
        ```
        View a song in a beautiful GNOME application.
        ```
        ![Song](card-large-song.png)
    }
    @Tab("Welcome screen") {
        ```
        Open songs from your library with *ChordPro* songs.
        ```
        ![Welcome](card-large-welcome.png)
    }
    @Tab("Editor screen") {
        Edit a song with *live* updates.
        ![Welcome](card-large-editor.png)
    }
    @Tab("MIDI player") {
        Play Grids and Tabs with MIDI.
        ![MIDI](card-large-midi-tab.png)
    }
    @Tab("Terminal") {
        Use **Chord Provider** in the `Terminal`.
        ![MIDI](card-large-cli.png)
    }
}

### Features

- View and edit ChordPro files
- Native Linux GUI with GNOME / libadwaita
- Built-in chord database
- MIDI playback for chords, grids and tabs
- Basic metronome
- Left-handed chord support

### The icon

Of course it is based on a **Telecaster**.

In 2016 I fell in love with an *Olympic White* Telecaster. The icon shape and colors are inspired by that guitar.

![Chord Provider icon](icon-app.png)

### A note about Swift

I originally started learning Swift for macOS development and stayed with the language because I genuinely enjoy using it.

I moved away from Apple platforms, but kept using Swift. The language itself was never really the problem.

And yes, my very first Swift course used Taylor Swift songs in many code examples, so that is how I accidentally learned about Taylor Swift and became a *real* Swifty :-D

## Topics

- <doc:Table-of-Contents>

### Source Code API documentation

The `Source Code` of **Chord Provider** is split into a couple of *Swift Packages*, each having its own purpose:

-  ``/ChordProviderCore``
-  ``/ChordProviderGnome``
-  ``/ChordProviderEditor``
-  ``/ChordProviderMIDI``
-  ``/ChordProviderCLI``
