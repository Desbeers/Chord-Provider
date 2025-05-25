# ``Chord_Provider``

A **ChordPro** viewer, editor and PDF exporter for macOS

## Overview

![Icon](https://github.com/Desbeers/Chord-Provider/raw/main/Images/icon.png)

### ChordPro

**ChordPro** is an open standard text format and its has an [official reference implementation](https://www.chordpro.org/chordpro/chordpro-directives/). While I hope you like **Chord Provider**, as *guitar player* or *macOS programmer*, it is just my hobby project.

### Chord Provider

**Chord Provider** is written in Swift 6 and SwiftUI and needs macOS Sequoia.

![Chord Provider](https://github.com/Desbeers/Chord-Provider/raw/main/Images/screenshot-macOS.jpg)

There are many [ChordPro](https://www.chordpro.org) parsers in this world, however, almost none are *really* native in the *macOS* world, it is often an afterthought... Not for me. I'm *Mac* user only and I don't use *iStuff*.

#### The icon

A **Telecaster** shape, of course! In mid 2016, I felt in love with a guitar. An *Olympic White*. That is the color of the shape. The background is a suitable modification of her 'plate'.

### What can **Chord Provider** do?

- It will view your **ChordPro** files.
- It can export your song as a PDF document or a whole folder with **ChordPro** songs to a PDF with a *Table of Contents*
- It has a fancy editor to edit your songs
- It can play the chords with MIDI with a guitar instrument that you can select in the `settings`
- It can play audio songs or videos when stored next to the **ChordPro** file
- It has a *database* with a lot of chords.
- *left-handed* chords support

#### Optional use the **ChordPro CLI reference implementation** for PDF creation

The [official reference implementation](https://www.chordpro.org/) of the **ChordPro** format is *much* more powerful to create PDF's.

If you have the CLI utility installed on your system, **Chord Provider** can optional use it for creating PDF's.

### A *true* macOS application

- It has a *quicklook* plugin for **ChordPro** files. Select a song in the *Finder* and press `space`.
- It makes *thumbnails* for your **ChordPro** files with the **Chord Provider** icon and the name on the song below. True eye candy!

Besides that; its an interesting project for *macOS* programmers. It renders PDF's; use the `ViewThatFits` magic to show a song in columns, playing MIDI with *CoreAudio* and deals with the `DocumentGroup` beast...

It's editor is written from scratch; in `AppKit`.

While I studied a lot of code from other projects to learn; in the end, its all included. I don't like dependencies!

## Topics

### General

- ``AlertMessage``
- ``AppError``
- ``AppSettings``
- ``Help``
- ``LogMessage``
- ``SFSymbol``

### Documents

All the file types **Chord Provider** can handle

- ``ChordProDocument``
- ``JSONDocument``
- ``ExportDocument``

### ChordPro

Bits and pieces for a **ChordPro** file

- ``ChordPro``
- ``ChordProConfig``
- ``ChordProCLI``
- ``ChordProConfig``

### **ChordPro** parser

All files needed for parsing a **ChordPro** song

- ``ChordProParser``
- ``Song``
- ``Artist``
- ``Instrument``

### **ChordPro** editor

- ``ChordProEditor``
- ``ChordProEditorDelegate``
- ``Editor``

### Chord Definitions

- ``Chord``
- ``Chords``
- ``ChordDefinition``
- ``RegexDefinitions``

### Utilities

- ``ChordUtils``
- ``FontUtils``
- ``SongFileUtils``
- ``UserFileUtils``

### Cache

- ``ImageCache``
- ``SettingsCache``

### Midi

Convert a ``ChordDefinition`` to Midi values and play it with Core Audio

- ``Midi``
- ``MidiPlayer``

### Observable Models

Models used by the SwiftUI Views

- ``AppStateModel``
- ``SceneStateModel``
- ``ChordsDatabaseStateModel``
- ``FileBrowserModel``
- ``ImageViewModel``
- ``MetronomeModel``

### SwiftUI General

- ``ChordProviderApp``
- ``AppDelegate``
- ``AppKitUtils``


### SwiftUI Main Scene
- ``MainView``
- ``ToolbarView``
- ``HeaderView``
- ``SplitterView``
- ``SongView``
- ``RenderView``
- ``ChordsView``
- ``EditorView``
- ``PreviewPaneView``

### SwiftUI About Scene

- ``AboutView``

### SwiftUI Welcome Scene

- ``WelcomeView``

### SwiftUI Chords Database Scene

- ``ChordsDatabaseView``

### SwiftUI Export Folder Scene

- ``ExportFolderView``

### SwiftUI Media Player Scene

- ``MediaPlayerView``

### SwiftUI Settings Scene

- ``SettingsView``

### SwiftUI Help Scene

- ``HelpView``

### SwiftUI Debug Scene

- ``DebugView``

### SwiftUI Shared Views

SwiftUI Views used all around the application

- ``ColumnsLayout``
- ``ChordDefinitionView``
- ``CreateChordView``
- ``FontOptionsView``
- ``ArrowView``
- ``Styles``
- ``Modifiers``

### SwiftUI Button Views

SwiftUI buttons used all around the application

- ``ExportSongButton``
- ``DebugButtons``
- ``FontSizeButtons``
- ``MetronomeButton``
- ``ColorPickerButton``
- ``UserFileButton``
- ``PreviewPDFButton``
- ``PrintPDFButton``
- ``ShareButton``
- ``HelpButtons``
- ``FontPickerButton``
- ``PlayChordButton``

### SwiftUI Slider Views

SwiftUI sliders used all around the application

- ``SizeSlider``

### SwiftUI Picker Views

SwiftUI pickers used all around the application

- ``FontPicker``

### PDF renderer

- ``PDFBuild``
- ``PDFElement``
- ``SongExport``
- ``FolderExport``
