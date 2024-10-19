//
//  AppStateModel+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

// MARK: Buttons

extension AppStateModel {

    // MARK: Play Button

    /// SwiftUI `Button` to play the chord with MIDI
    struct PlayButton: View {
        /// The chord to play
        let chord: ChordDefinition
        let instrument: Midi.Instrument
        /// The body of the `View`
        var body: some View {
            Button(action: {
                chord.play(instrument: instrument)
            }, label: {
                Label("Play", systemImage: "play.fill")
            })
            .disabled(chord.frets.isEmpty)
        }
    }
}

// MARK: Toggles

extension AppStateModel {

    // MARK: Repeat Whole Chorus Toggle

    /// SwiftUI `View` with a `Toggle` to show the whole last chorus when using a *{chorus}* directive
    var repeatWholeChorusToggle: some View {
        RepeatWholeChorusToggle(appState: self)
    }
    /// SwiftUI `View` with a `Toggle` to show the whole last chorus when using a *{chorus}* directive
    struct RepeatWholeChorusToggle: View {
        /// Chord Display Options object
        @Bindable var appState: AppStateModel
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $appState.settings.song.repeatWholeChorus) {
                Text("Repeat whole chorus")
                Text("When enabled, the **{chorus}** directive will be replaced by the whole last found chorus with the same label.")
            }
        }
    }

    // MARK: Lyrics Only Toggle

    /// SwiftUI `View` with a `Toggle` to show only the lyrics
    var lyricsOnlyToggle: some View {
        LyricsOnlyToggle(appState: self)
    }
    /// SwiftUI `View` with a `Toggle` to show only the lyrics
    struct LyricsOnlyToggle: View {
        /// Chord Display Options object
        @Bindable var appState: AppStateModel
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $appState.settings.song.lyricsOnly) {
                Text("Show only lyrics")
                Text("This option will hide all chords.")
            }
        }
    }

    // MARK: Name Toggle

    /// SwiftUI `View` with a `Toggle` to show or hide the name on the diagram
    var nameToggle: some View {
        NameToggle(appState: self)
    }
    //// SwiftUI `View` with a `Toggle` to show or hide the name on the diagram
    struct NameToggle: View {
        /// App State
        @Bindable var appState: AppStateModel
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $appState.settings.diagram.showName) {
                Label("Show name", systemImage: appState.settings.diagram.showName ? "a.square.fill" : "a.square")
            }
        }
    }

    // MARK: Fingers Toggle

    /// SwiftUI `View` with a `Toggle` to show or hide the fingers on the diagram
    var fingersToggle: some View {
        FingersToggle(appState: self)
    }
    /// SwiftUI `View` with a `Toggle` to show or hide the fingers on the diagram
    struct FingersToggle: View {
        /// Chord Display Options object
        @Bindable var appState: AppStateModel
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .top) {
                Image(
                    systemName: appState
                        .settings
                        .diagram
                        .showFingers ? "hand.raised.fingers.spread.fill" : "hand.raised.fingers.spread"
                )
                Toggle(isOn: $appState.settings.diagram.showFingers) {
                    Text("Show fingers")
                    Text("Show the suggested finger positions for the chord")
                }
            }
        }
    }

    // MARK: Notes Toggle

    /// SwiftUI `View` with a `Toggle` to show or hide the notes on the diagram
    var notesToggle: some View {
        NotesToggle(appState: self)
    }
    /// SwiftUI `View` with a `Toggle` to show or hide the notes on the diagram
    struct NotesToggle: View {
        /// Chord Display Options object
        @Bindable var appState: AppStateModel
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: "music.note.list")
                Toggle(isOn: $appState.settings.diagram.showNotes) {
                    Text("Show notes")
                    Text("Show the notes of the chord underneath the diagram")
                }
            }
        }
    }

    // MARK: Mirror Toggle

    /// SwiftUI `View` with a `Toggle`  to mirror the diagram
    var mirrorToggle: some View {
        MirrorToggle(appState: self)
    }
    /// SwiftUI `View` with a `Toggle`  to mirror the diagram
    struct MirrorToggle: View {
        /// Chord Display Options object
        @Bindable var appState: AppStateModel
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: appState.settings.diagram.mirrorDiagram ? "hand.point.left.fill" : "hand.point.right.fill")
                Toggle(isOn: $appState.settings.diagram.mirrorDiagram) {
                    Text("Mirror diagram")
                    Text("Flip the finger positions for left-handed players")
                }
            }
        }
    }

    // MARK: Play Toggle

    /// SwiftUI `View` with a `Toggle` to show or hide the play button
    var playToggle: some View {
        PlayToggle(appState: self)
    }
    /// SwiftUI `View` with a `Toggle`  to show or hide the play button
    struct PlayToggle: View {
        /// Chord Display Options object
        @Bindable var appState: AppStateModel
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: appState.settings.diagram.showPlayButton ? "play.fill" : "play")
                Toggle(isOn: $appState.settings.diagram.showPlayButton) {
                    Text("Show play button")
                    Text("Play the chord with MIDI")
                }
            }
        }
    }
}

// MARK: Pickers

extension AppStateModel {

    // MARK: Midi Instrument Picker

    /// SwiftUI `Picker` to select a MIDI ``Midi/Instrument`` value
    var midiInstrumentPicker: some View {
        MidiInstrumentPicker(appState: self)
    }
    /// SwiftUI `Picker` to select a MIDI ``Midi/Instrument`` value
    struct MidiInstrumentPicker: View {
        /// Chord Display Options object
        @Bindable var appState: AppStateModel
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                Label("MIDI Instrument", systemImage: "guitars.fill")

                //Image(systemName: "guitars.fill")
                Picker("MIDI Instrument:", selection: $appState.settings.diagram.midiInstrument) {
                    ForEach(Midi.Instrument.allCases) { value in
                        Text(value.label)
                            .tag(value)
                    }
                }
                .frame(maxWidth: 180)
                .labelsHidden()
                .disabled(!appState.settings.diagram.showPlayButton)
            }
        }
    }
}
