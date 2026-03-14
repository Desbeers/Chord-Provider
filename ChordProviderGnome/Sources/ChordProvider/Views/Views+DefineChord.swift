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
    struct DefineChord: View {
        /// The state of the chord definition
        @Binding var definition: ChordDefinition
        /// Bool if the chord definition is new
        let newChord: Bool
        /// The application settings
        let appSettings: AppSettings
        /// The slash is *optional* so it needs its own handler
        @State private var slash: Chord.Root = .none
        /// Label for not pplaying a string
        static let doNotPlay = "Don't play this string"
        /// Toast signal when a definition is copied
        @State private var copied = Signal()
        /// Calculated definition
        var define: String {
            "{define-\(definition.instrument.type.rawValue) \(definition.define)}"
        }
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
            if appSettings.core.diagram.mirror {
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
            if appSettings.core.diagram.mirror {
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
                kind: .standardChord
            )
        }
        /// The body of the `View`
        var view: Body {
            VStack(spacing: 10) {
                HStack {
                    Text(define)
                    Button(icon: .default(icon: .editCopy)) {
                        AdwaitaApp.copy(define)
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
                    values: Chord.Root.allCases.dropFirst().dropLast(),
                    id: \.self,
                    label: \.display
                )
                /// Disable above when a definition is edited
                .insensitive(!newChord)
                HStack(spacing: 10) {
                    Text("Quality:")
                    DropDown(
                        selection: $definition.quality.onSet { _ in
                            lookupChord()
                        },
                        values: Array(Chord.Quality.allCases.dropFirst().dropLast())
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
                            preset: appSettings.core.midiPreset
                        )
                        Views.ChordDiagram(
                            chord: definition,
                            width: 160,
                            coreSettings: appSettings.core
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
                           .padding(.top)
                        Separator()
                        VStack {
                            ForEach(strings, horizontal: true) { string in
                                /// I cannot use a `ToggleGroup` because the chord names change with the base fret
                                ForEach(string.frets) { button in
                                    if let icon = button.icon {
                                        Button(icon: icon) {
                                            definition.frets[string.id] = button.id
                                            playNote(string)
                                        }
                                        .style("circular")
                                        .flat(definition.frets[string.id] != button.id)
                                        .tooltip(button.label)
                                    } else {
                                        Button(button.label) {
                                            definition.frets[string.id] = button.id
                                            playNote(string)
                                        }
                                        .style("circular")
                                        .flat(definition.frets[string.id] != button.id)
                                    }
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
                                ToggleGroup(
                                    selection: $definition.fingers[finger.id],
                                    values: finger.frets,
                                    id: \.id,
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
                            title: definition.display
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
                    let preset = appSettings.core.midiPreset
                    Task {
                        await Utils.MidiPlayer.shared.playNotes([Int32(note)], preset: preset)
                    }
                }
            }
        }

        /// Try to find a chord in the database
        private func lookupChord() {
            if newChord {
                let definition = appSettings.core.database.definitions
                    .matching(root: definition.root)
                    .matching(quality: definition.quality)
                    .matching(slash: definition.slash)
                    .matching(baseFret: definition.baseFret)


                if let definition = definition.first {
                    self.definition = definition
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
