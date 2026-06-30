# ``ChordProviderGnome``

@Metadata {
    @DisplayName("Chord Provider GNOME")
    @PageImage(purpose: card, source: card-large-song, alt: Icon)
}

The **Chord Provider** GUI for Linux

## Overview

**Chord Provider** for [GNOME](https://www.gnome.org/) is written in Swift and uses [Adwaita for Swift](https://git.aparoksha.dev/aparoksha/adwaita-swift).

![Chord Provider](card-large-song.png)

There are many ChordPro parsers and editors available, but very few feel truly native on Linux desktops. That is what I wanted to build.

The application started as a macOS SwiftUI project, but was later rewritten for Linux with a native GNOME interface.

It is an interesting combination... `Swift` and `GTK/LibAdwaita` but it works remarkable well. `Adwaita for Swift` has a lot in common wth `SwiftUI`, except it is *Open Source* and works great on Linux. I like the looks of  *real* GNOME application very much.

### Building

The recommended way to build **Chord Provider** is as a Flatpak application.
,
Clone the repository and build it with [GNOME Builder](https://apps.gnome.org/en-GB/Builder/).

## Topics

### Adwaita Views

- ``ChordProviderApp``
- ``Views``
- ``Widgets``
- ``GtkRender``

### Application State

- ``AppState``
- ``DatabaseState``
- ``AppSettings``
- ``RecentSongs``

### Remaining

- ``Markup``
- ``Utils``
