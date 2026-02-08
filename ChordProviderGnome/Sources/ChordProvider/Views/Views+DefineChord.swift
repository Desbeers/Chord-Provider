//
//  Views+DefineChord.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` to define a chord
    struct DefineChord: View {
        init(appState: Binding<AppState>) {
            var newChord = true
            var definition = ChordDefinition(name: "C", instrument: appState.wrappedValue.editor.song.settings.instrument)!
            /// Check if we are called as *edit* the definition instead of a new one
            if appState.editor.showEditDirectiveDialog.wrappedValue {
                if let currentDefinition = try? ChordDefinition(
                    definition: appState.editor.currentLine.plain.wrappedValue ?? "",
                    kind: .customChord, instrument: appState.editor.song.settings.instrument.wrappedValue
                ) {
                    definition = currentDefinition
                    newChord = false
                }
            }
            self._appState = appState
            self._definition = State(wrappedValue: definition)
            self.newChord = newChord
        }
        /// The state of the application
        @Binding var appState: AppState
        /// Bool if the chord definition is new
        let newChord: Bool
        /// The state of the chord definition
        @State private var definition: ChordDefinition
        /// The slash is *optional* so it needs its own handler
        @State private var slash: Chord.Root = .none
        /// Don't play optional MIDI before the`View` is completely loaded
        @State var loaded: Bool = false
        /// Calculated definition
        var define: String {
            "{define-\(definition.instrument.rawValue) \(definition.define)}"
        }
        /// Calculated note values for the strings
        var strings: [StringNumber] {
            var result: [StringNumber] = []
            for string in definition.instrument.strings {
                var frets = [Fret]()
                /// Don't play
                frets.append(Fret(value: -1, label: "Don't play this string"))
                for fret in (0...5) {
                    /// Calculate the fret note
                    /// - Note: Only add the base fret after the first row because the note can still be played open
                    let fretNote = definition
                        .instrument.offset[string] + (string == 0 ? 1 : definition.baseFret.rawValue) + 40 + fret
                    /// Convert the fret to a label
                    let label = ChordUtils.valueToNote(value: fretNote, scale: definition.root).display
                    frets.append(Fret(value: fret, label: label))
                }
                result.append(StringNumber(id: string, frets: frets))
                frets = [Fret]()
            }
            return result
        }
        /// Calculated finger positions
        var fingers: [FingerNumber] {
            var result: [FingerNumber] = []
            for string in definition.instrument.strings {
                var fingers = [Finger]()
                fingers.append(Finger(value: 0, label: "Don't play this string"))
                for finger in (1...5) {
                    fingers.append(Finger(value: finger, label: "\(finger)"))
                }
                result.append(FingerNumber(id: string, fingers: fingers))
                fingers = [Finger]()
            }
            return result
        }
        /// Calculated chord definition
        var getDefinition: ChordDefinition {
            ChordDefinition(
                id: definition.id,
                frets: definition.frets,
                fingers: definition.fingers,
                baseFret: definition.baseFret,
                root: definition.root,
                quality: definition.quality,
                slash: definition.slash,
                instrument: definition.instrument,
                kind: .standardChord
            )
        }
        /// The body of the `View`
        var view: Body {
            VStack(spacing: 10) {
                Text(define)
                    .caption()
                ToggleGroup(
                    selection: $definition.root,
                    values: Chord.Root.allCases.dropFirst().dropLast(),
                    id: \.self,
                    label: \.display
                )
                /// Disable above when a definition is edited
                .insensitive(!newChord)
                HStack(spacing: 10) {
                    Text("Quality:")
                    DropDown(
                        selection: $definition.quality,
                        values: Array(Chord.Quality.allCases.dropFirst().dropLast())
                    )
                    /// Disable above when a definition is edited
                    .insensitive(!newChord)
                    Text("Base fret:")
                    DropDown(
                        selection: $definition.baseFret,
                        values: Chord.BaseFret.allCases
                    )
                    Text("Optional bass:")
                    DropDown(
                        selection: $slash.onSet { definition.slash = $0 == .none ? nil : $0 },
                        values: Array(Chord.Root.allCases.dropFirst())
                    )
                    /// Disable above when a definition is edited
                    .insensitive(!newChord)
                }
                HStack(spacing: 20) {
                    VStack {
                        let definition = getDefinition
                        MidiPlayer(
                            chord: definition,
                            preset: appState.settings.core.midiPreset
                        )
                        Views.ChordDiagram(
                            chord: definition,
                            width: 160,
                            settings: appState.editor.song.settings
                        )
                        Text(definition.notesLabel)
                            .useMarkup()
                        let validate = definition.validate
                        Text(validate.description)
                            .wrap()
                            .style(validate == .correct ? .none : .error)
                            .caption()
                            .padding(.top)
                            .frame(maxWidth: 160)
                            .id(validate.description)
                    }
                    VStack(spacing: 10) {
                        Text("Frets")
                        Separator()
                        VStack {
                            ForEach(strings, horizontal: true) { string in
                                ToggleGroup(
                                    selection: $definition.frets[string.id].onSet { _ in
                                        playNote(string)
                                    },
                                    values: string.frets,
                                    id: \.value,
                                    label: \.label,
                                    icon: \.icon,
                                    showLabel: \.showLabel
                                )
                                .vertical()
                                .flat()
                                .round()
                            }
                        }
                        .vexpand()
                    }
                    Separator()
                    VStack(spacing: 10) {
                        Text("Fingers")
                        Separator()
                        VStack {
                            ForEach(fingers, horizontal: true) { finger in
                                ToggleGroup(
                                    selection: $definition.fingers[finger.id],
                                    values: finger.fingers,
                                    id: \.value,
                                    label: \.label,
                                    icon: \.icon,
                                    showLabel: \.showLabel
                                )
                                .vertical()
                                .flat()
                                .round()
                            }
                        }
                        .vexpand()
                    }
                }
                Separator()
                HStack {
                    SwitchRow()
                        .title("Play notes")
                        .active($appState.settings.app.soundForChordDefinitions)
                    HStack(spacing: 10) {
                        DropDown(
                            selection: $appState.settings.core.midiPreset,
                            values: MidiUtils.Preset.allCases
                        )
                        .insensitive(!appState.settings.app.soundForChordDefinitions)
                        Separator()
                        Button("Cancel") {
                            appState.editor.showEditDirectiveDialog = false
                        }
                        Button("\(newChord ? "Add" : "Update") Definition") {
                            if newChord {
                                appState.editor.command = .appendText(text: define)
                            } else {
                                appState.editor.command = .replaceLineText(text: define)
                            }
                            appState.editor.showEditDirectiveDialog = false
                        }
                        .suggested()
                    }
                    .valign(.center)
                }
                .halign(.center)
            }
            .style(.define)
            .padding([.leading, .trailing, .bottom])
            .topToolbar {
                HeaderBar.empty()
                    .headerBarTitle {
                        WindowTitle(
                            subtitle: definition.quality.intervalsLabel,
                            title: definition.display
                        )
                    }
            }
            .onUpdate {
                /// Set loaded state, optional enabling MIDI sounds
                if !self.loaded {
                    self.loaded = true
                }
            }
        }

        // MARK: Functions

        /// Play a chord note with MIDI
        /// - Parameter string: The string number to play
        private func playNote( _ string: StringNumber) {
            if self.loaded, appState.settings.app.soundForChordDefinitions {
                let chord = getDefinition
                let notes = chord.components.map(\.midi)
                if let note = notes[string.id] {
                    let preset = appState.settings.core.midiPreset
                    Task {
                        await Utils.MidiPlayer.shared.playNotes([Int32(note)], preset: preset)
                    }
                }
            }
        }

        // MARK: String, fret and finger structures

        struct StringNumber: Identifiable {
            let id: Int
            let frets: [Fret]
        }

        struct Fret {
            var icon: Adwaita.Icon? {
                switch self.value {
                case -1: .default(icon: .dialogError)
                default: nil
                }
            }
            var showLabel: Bool {
                switch self.value {
                case -1: false
                default: true
                }
            }
            let value: Int
            let label : String
        }

        struct FingerNumber: Identifiable {
            let id: Int
            let fingers: [Finger]
        }

        struct Finger {
            var icon: Adwaita.Icon? {
                switch self.value {
                case 0: .default(icon: .dialogError)
                default: nil
                }
            }
            var showLabel: Bool {
                switch self.value {
                case 0: false
                default: true
                }
            }
            let value: Int
            let label : String
        }
    }
}
