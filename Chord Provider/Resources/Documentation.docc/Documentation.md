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

### Documents

All the file types **Chord Provider** can handle

Obviously, **Chord Provider** can open and save **ChordPro** files.

It can also import and export JSON configuration files. Official **ChordPro** configurations
as well *themes* used in **Chord Provider**.

The *export document* is a PDF with either a song or a whole folder with songs.

- ``ChordProDocument``
- ``JSONDocument``
- ``ExportDocument``
- ``Samples``

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

### **ChordPro** editor

The **ChordPro** editor is written in `AppKit`. SwiftUI's editor is simply too limited. It does *highlight* directives and chords and you can edit them in a sheet by *double click* on them.

While working well for *normal* songs it will be a bit sluggish on long documents. It is written in *textkit 1* for now but a *textkit 2* version is in development.

- ``ChordProEditor``
- ``ChordProEditorDelegate``
- ``Editor``

### Chord Definitions

- ``Chord``
- ``ChordDefinition``

### Utilities

- ``ChordUtils``
- ``FontUtils``
- ``ImageUtils``
- ``JSONUtils``
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

**Chord Provider** is mostly written in SwiftUI. For some parts I have to fall-back to `AppKit` but over the years less and less. SwiftUI on macOS is pretty ok nowadays.

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

The *standard* About Window sucks. I know how to style it a bit but it does not fit in the SwiftUI world. I just added another `scene` to make it modern.

- ``AboutView``

### SwiftUI Welcome Scene

Fortunately, I can add a *Welcome Scene* with macOS Sequoia now for a *document based application*. Still some dirty hacks needed the *dismiss* its Window. But its getting better!

- ``WelcomeView``

### SwiftUI Chords Database Scene

While not a *document* View; it *does* let you alter the database so I have to apply some `AppKit` magic to track the state of the database.

- ``ChordsDatabaseView``

### SwiftUI Export Folder Scene

- ``ExportFolderView``

### SwiftUI Media Player Scene

When you have an audio or video file next to your **ChordPro** song with the same base name, **Chord Provider** can play it. One of the reasons **Chord Provider** is *not* sandboxed...

- ``MediaPlayerView``

### SwiftUI Settings Scene

Just a *native* SwiftUI Settings View; as you would expect.

- ``SettingsView``

### SwiftUI Help Scene

To get a *native* macOS Help, you have to compile a *Help Book*. While I did that in the past, I gave up... Its horrible and does not fit well with the declarative nature of SwiftUI. So, I just added another `Scene` for it, showing a song with *help* in PDF format. With fancy buttons to change its appearance.

- ``HelpView``

### SwiftUI Debug Scene

**Chord Provider** parses the **ChordPro** file into a ``Song`` structure and logs its progress. The *Debug Scene* let you view the result and logs.

- ``DebugView``

### SwiftUI Shared Views

SwiftUI Views used all around the application

- ``ColumnsLayout``
- ``ChordDefinitionView``
- ``CreateChordView``
- ``FontOptionsView``
- ``C64View``
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
- ``ExportJSONButton``
- ``C64Button``

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
