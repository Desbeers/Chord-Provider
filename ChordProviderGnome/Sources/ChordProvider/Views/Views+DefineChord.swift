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
        let newChord: Bool
        /// The state of the application
        @Binding var appState: AppState
        @State private var definition: ChordDefinition
        /// The slash is *optional* so it needs its own handler
        @State private var slash: Chord.Root = .none
        /// Calculated definition
        var define: String {
            "{define-\(definition.instrument.rawValue) \(definition.define)}"
        }
        /// The body of the `View`
        var view: Body {
            VStack(spacing: 10) {
                Text(define)
                    .caption()
                ToggleGroup(
                    selection: $definition.root,
                    values: Chord.Root.allCases.dropFirst().dropLast()
                )
                /// Disable above when a definition is edited
                .insensitive(!newChord)
                HStack(spacing: 10) {
                    Text("Quality:")
                    DropDown(selection: $definition.quality, values: Array(Chord.Quality.allCases.dropFirst().dropLast()))
                    /// Disable above when a definition is edited
                    .insensitive(!newChord)
                    Text("Base fret:")
                    /// - Note: Make this better
                    DropDown(selection: $definition.baseFret, values: Chord.BaseFret.allCases)
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
                        MidiPlayer(chord: definition)
                        diagramView()
                        Text(definition.notesLabel)
                            .useMarkup()
                        let validate = getDefinition().validate
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
                                Widgets.MyToggleGroup(
                                    selection: $definition.frets[string.id],
                                    values: string.frets
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
                                Widgets.MyToggleGroup(
                                    selection: $definition.fingers[finger.id],
                                    values: finger.fingers
                                )
                                .vertical()
                                .flat()
                                .round()
                            }
                        }
                        .vexpand()
                    }
                }
                HStack(spacing: 10) {
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
        }

        func getDefinition() ->ChordDefinition {
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

        @ViewBuilder func diagramView() -> Body {
            Views.ChordDiagram(
                chord: getDefinition(),
                width: 160,
                settings: appState.editor.song.settings
            )
        }

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

        struct StringNumber: Identifiable {
            let id: Int
            let frets: [Fret]
        }

        struct Fret: ToggleGroupItem, CustomStringConvertible {
            var description: String {
                label
            }
            var icon: Adwaita.Icon? {
                switch self.value {
                case -1:
                        .default(icon: .dialogError)
                default:
                    nil
                }
            }
            var showLabel: Bool { true }
            var id: Int {
                value
            }
            let value: Int
            let label : String
        }

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

        struct FingerNumber: Identifiable {
            let id: Int
            let fingers: [Finger]
        }

        struct Finger: ToggleGroupItem, CustomStringConvertible {
            var description: String {
                label
            }
            var icon: Adwaita.Icon? {
                switch self.value {
                case 0:
                        .default(icon: .dialogError)
                default:
                    nil
                }
            }
            var showLabel: Bool { true }
            var id: Int {
                value
            }
            let value: Int
            let label : String
        }
    }

}


