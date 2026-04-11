//
//  Views+DefineChord.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import CAdw

extension Views {

    /// The `View` to define a chord
    /// 
    /// This `View` is *not* complete, it is just showing the edit dialog.
    /// It is used by the Editor and by the Database views to show a complete `View`
    struct DefineChord: View {
        /// The state of the chord definition
        @Binding var definition: ChordDefinition
        /// Bool if the chord definition is new
        let newChord: Bool
        /// Bool if `sharp` and `flat` should be merged
        /// - Note: Used when editing a chord for the Database
        let mergeSharpAndFlat: Bool
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The application settings
        let appSettings: AppSettings
        /// The slash is *optional* so it needs its own handler
        @State private var slash: Chord.Root = .none
        /// Label for not playing a string
        static let doNotPlay = "Don't play this string"
        /// Toast signal when a definition is copied
        @State private var copied = Signal()
        /// Calculated note values for the strings
        var strings: [StringNumber] {
            var result: [StringNumber] = []
            for string in definition.instrument.strings {
                var frets = [Fret]()
                /// Don't play
                frets.append(Fret(id: -1, label: DefineChord.doNotPlay))
                for fret in (0...5) {
                    /// Calculate the fret note
                    /// - Note: Only add the base fret after the first row because the note can still be played open
                    let fretNote = definition
                        .instrument.offsets[string] + (fret == 0 ? 1 : definition.baseFret.rawValue) + 40 + fret
                    /// Convert the fret to a label
                    let label = ChordUtils.valueToNote(value: fretNote, scale: definition.root).display
                    frets.append(Fret(id: fret, label: label))
                }
                result.append(StringNumber(id: string, frets: frets))
                frets = [Fret]()
            }
            /// Mirror if needed
            if coreSettings.diagram.mirror {
                result.reverse()
            }
            return result
        }
        /// Calculated finger positions
        var fingers: [StringNumber] {
            var result: [StringNumber] = []
            for string in definition.instrument.strings {
                var fingers = [Fret]()
                fingers.append(Fret(id: 0, label: DefineChord.doNotPlay))
                for finger in (1...5) {
                    fingers.append(Fret(id: finger, label: "\(finger)"))
                }
                result.append(StringNumber(id: string, frets: fingers))
                fingers = [Fret]()
            }
            /// Mirror if needed
            if coreSettings.diagram.mirror {
                result.reverse()
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
                kind: .customChord,
                status: .unknownStatus
            )
        }
        /// The body of the `View`
        var view: Body {
            VStack(spacing: 10) {
                HStack {
                    Text(definition.define)
                    Button(icon: .default(icon: .editCopy)) {
                        AdwaitaApp.copy(definition.define)
                        copied.signal()
                    }
                    .flat(true)
                    .padding(.leading)
                }
                .caption()
                .halign(.center)
                ToggleGroup(
                    selection: $definition.root.onSet { _ in
                        lookupChord()
                    },
                    values: mergeSharpAndFlat ? Chord.Root.naturalAndSharp : Chord.Root.allCases.dropFirst().dropLast(),
                    id: \.self,
                    label: mergeSharpAndFlat ? \.naturalAndSharpDisplay : \.display
                )
                /// Disable above when a definition is edited
                .insensitive(!newChord)
                HStack(spacing: 10) {
                    Text("Quality:")
                    DropDown(
                        selection: $definition.quality.onSet { _ in
                            lookupChord()
                        },
                        values: Array(Chord.Quality.allCases.dropFirst().dropLast()),
                        id: \.id,
                        description: \.description
                    )
                    /// Disable above when a definition is edited
                    .insensitive(!newChord)
                    Text("Base fret:")
                    DropDown(
                        selection: $definition.baseFret.onSet { _ in
                            lookupChord()
                        },
                        values: Chord.BaseFret.allCases
                    )
                    Text("Optional bass:")
                    DropDown(
                        selection: $slash.onSet {
                            definition.slash = $0 == .none ? nil : $0
                            lookupChord()
                        },
                        values: Array(Chord.Root.allCases.dropFirst()),
                        id: \.id,
                        description: \.display
                    )
                    /// Disable above when a definition is edited
                    .insensitive(!newChord)
                }
                HStack(spacing: 20) {
                    VStack {
                        let definition = getDefinition
                        MidiPlayer(
                            chord: definition,
                            coreSettings: coreSettings
                        )
                        Views.ChordDiagram(
                            chord: definition,
                            width: 160,
                            coreSettings: coreSettings
                        )
                        Text(definition.notesLabel)
                            .useMarkup()
                        if !definition.validationWarnings.isEmpty {
                            ScrollView {
                                HStack(spacing: 4) {
                                    ForEach(definition.validationWarnings, id: \.description) { line in
                                        Text("- \(line.description)")
                                            .useMarkup()
                                            .halign(.start)
                                            .id(line.description)
                                    }
                                }
                                .padding()
                            }
                            .hscrollbarPolicy(.never)
                            .caption()
                            .halign(.center)
                            .style(.error)
                            .transition(.crossfade)
                        }
                    }
                    /// Make sure all warnings fits or else the window will resize
                    .frame(maxWidth: 340)
                    .frame(minWidth: 340)
                    VStack(spacing: 10) {
                        Text("Frets")
                           .padding(.top)
                        Separator()
                        VStack {
                            ForEach(strings, horizontal: true) { string in
                                ForEach(string.frets) { button in
                                    Button(button, active: definition.frets[string.id] == button.id) {
                                        definition.frets[string.id] = button.id
                                        playNote(string)
                                    }
                                    .style("circular")
                                    .insensitive(button.id != -1 && !definition.notes.contains(button.label))
                                    .id(definition.description)
                                }
                            }
                        }
                        .vexpand()
                        .padding()
                    }
                    .card()
                    VStack(spacing: 10) {
                        Text("Fingers")
                            .padding(.top)
                        Separator()
                        VStack {
                            ForEach(fingers, horizontal: true) { finger in
                                ForEach(finger.frets) { button in
                                    Button(button, active: definition.fingers[finger.id] == button.id) {
                                        definition.fingers[finger.id] = button.id
                                    }
                                    .style("circular")
                                    .style(definition.correctFinger(string: finger.id) ? .none : definition.fingers[finger.id] == button.id ? .error : .none)
                                    .id(definition.description)
                                }
                            }
                        }
                        .vexpand()
                        .padding()
                    }
                    .card()
                }
            }
            .style(.define)
            .padding([.leading, .trailing, .bottom])
            .topToolbar {
                HeaderBar.empty()
                    .headerBarTitle {
                        WindowTitle(
                            subtitle: definition.quality.intervalsLabel,
                            title: mergeSharpAndFlat ? definition.displaySharpAndFlat : definition.display
                        )
                    }
            }
            .toast("Copied definition to clipboard", signal: copied)
        }

        // MARK: Functions

        /// Play a chord note with MIDI
        /// - Parameter string: The string number to play
        private func playNote( _ string: StringNumber) {
            if appSettings.app.soundForChordDefinitions {
                let chord = getDefinition
                let notes = chord.components.map(\.midi)
                if let note = notes[string.id] {
                    let preset = coreSettings.midiPreset
                    Task {
                        await Utils.MidiPlayer.shared.playNotes([note], preset: preset, strum: nil)
                    }
                }
            }
        }

        /// Try to find a chord in the database
        private func lookupChord() {
            if newChord {
                let definition = coreSettings.chordDefinitions
                    .matching(root: definition.root)
                    .matching(quality: definition.quality)
                    .matching(slash: definition.slash)
                    .matching(baseFret: definition.baseFret)

                if let definition = definition.first {
                    self.definition = definition
                } else {
                    self.definition.frets = Array(repeating: -1, count: self.definition.instrument.strings.count)
                    self.definition.fingers = Array(repeating: 0, count: self.definition.instrument.strings.count)
                }
            }
        }

        // MARK: String, fret and finger structures

        /// The strings of the instrument
        struct StringNumber: Identifiable {
            /// The ID of the string
            let id: Int
            /// The frets of the string
            let frets: [Fret]
        }

        /// The frets of the instrument
        struct Fret: Identifiable {
            /// The ID of the fret
            let id: Int
            /// The label of the fret
            let label: String
            /// The optional icon of the fret
            var icon: Adwaita.Icon? {
                switch self.label {
                case DefineChord.doNotPlay: .default(icon: .dialogError)
                default: nil
                }
            }
            /// Bool to show a label
            var showLabel: Bool {
                switch self.label {
                case DefineChord.doNotPlay: false
                default: true
                }
            }
        }
    }
}
