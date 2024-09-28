//
//  ChordDisplayOptions+toggles.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//


import SwiftUI

extension ChordDisplayOptions {

    // MARK: Name Toggle

    /// SwiftUI `View` with a `Toggle` to show or hide the name on the diagram
    public var nameToggle: some View {
        NameToggle(chordDisplayOptions: self)
    }
    //// SwiftUI `View` with a `Toggle` to show or hide the name on the diagram
    struct NameToggle: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $chordDisplayOptions.displayOptions.general.showName) {
                Label("Show name", systemImage: chordDisplayOptions.displayOptions.general.showName ? "a.square.fill" : "a.square")
            }
        }
    }

    // MARK: Fingers Toggle

    /// SwiftUI `View` with a `Toggle` to show or hide the fingers on the diagram
    public var fingersToggle: some View {
        FingersToggle(chordDisplayOptions: self)
    }
    /// SwiftUI `View` with a `Toggle` to show or hide the fingers on the diagram
    struct FingersToggle: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .top) {
                Image(
                    systemName: chordDisplayOptions
                        .displayOptions
                        .general
                        .showFingers ? "hand.raised.fingers.spread.fill" : "hand.raised.fingers.spread"
                )
                Toggle(isOn: $chordDisplayOptions.displayOptions.general.showFingers) {
                    Text("Show fingers")
                    Text("Show the suggested finger positions for the chord")
                }
            }
        }
    }

    // MARK: Notes Toggle

    /// SwiftUI `View` with a `Toggle` to show or hide the notes on the diagram
    public var notesToggle: some View {
        NotesToggle(chordDisplayOptions: self)
    }
    /// SwiftUI `View` with a `Toggle` to show or hide the notes on the diagram
    struct NotesToggle: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: "music.note.list")
                Toggle(isOn: $chordDisplayOptions.displayOptions.general.showNotes) {
                    Text("Show notes")
                    Text("Show the notes of the chord underneath the diagram")
                }
            }
        }
    }

    // MARK: Mirror Toggle

    /// SwiftUI `View` with a `Toggle`  to mirror the diagram
    public var mirrorToggle: some View {
        MirrorToggle(chordDisplayOptions: self)
    }
    /// SwiftUI `View` with a `Toggle`  to mirror the diagram
    struct MirrorToggle: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: chordDisplayOptions.displayOptions.general.mirrorDiagram ? "hand.point.left.fill" : "hand.point.right.fill")
                Toggle(isOn: $chordDisplayOptions.displayOptions.general.mirrorDiagram) {
                    Text("Mirror diagram")
                    Text("Flip the finger positions for left-handed players")
                }
            }
        }
    }

    // MARK: Play Toggle

    /// SwiftUI `View` with a `Toggle` to show or hide the play button
    public var playToggle: some View {
        PlayToggle(chordDisplayOptions: self)
    }
    /// SwiftUI `View` with a `Toggle`  to show or hide the play button
    struct PlayToggle: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: chordDisplayOptions.displayOptions.general.showPlayButton ? "play.fill" : "play")
                Toggle(isOn: $chordDisplayOptions.displayOptions.general.showPlayButton) {
                    Text("Show play button")
                    Text("Play the chord with MIDI")
                }
            }
        }
    }
}
