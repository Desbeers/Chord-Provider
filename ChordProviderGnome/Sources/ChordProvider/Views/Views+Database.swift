//
//  Views+Database.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` for showing the chord database
    struct Database: View {
        /// The core settings
        @State private var settings = ChordProviderSettings()
        /// The selected chord
        @State private var chord: Chord.Root = .c
        /// The optional search string
        @State private var search: String = ""
        /// The current selected diagram
        @State private var selection: UUID = UUID()
        /// Toast signal when a definition is copied
        @State private var copied: Signal = .init()
        /// The MIDI instrument to use
        @State private var midiInstrument: MidiUtils.Instrument = .acousticNylonGuitar
        /// The body of the `View`
        var view: Body {
            let chords = getChords()
            VStack {
                if search.isEmpty {
                    ToggleGroup(
                        selection: $chord,
                        values: Chord.Root.naturalAndSharp.dropFirst().dropLast()
                    )
                    .transition(.coverUpDown)
                }
                ScrollView {
                    if chords.isEmpty {
                        StatusPage(
                            "No chords found",
                            icon: .default(icon: .systemSearch),
                            description: "Oops! We couldn't find any chords that match your search."
                        )
                    } else {
                        FlowBox(chords, selection: $selection) { chord in
                            VStack {
                                MidiPlayer(chord: chord, midiInstrument: .acousticNylonGuitar)
                                ChordDiagram(chord: chord, settings: settings)
                            }
                        }
                        .valign(.start)
                        .padding()
                    }
                }
                .vexpand()
                Separator()
                VStack {
                    if let chord = chords.first(where: { $0.id == selection }) {
                        HStack(spacing: 10) {
                            ChordDiagram(chord: chord, width: 120, settings: settings)
                            VStack {
                                Views.MidiPlayer(chord: chord, midiInstrument: midiInstrument)
                                    .padding(.bottom)
                                Text(chord.quality.intervalsLabel)
                                    .style(.subtitle)
                                HStack {
                                    Text("{define-\(chord.instrument.rawValue) \(chord.define)}")
                                        .selectable()
                                    Button(icon: .default(icon: .editCopy)) {
                                        AdwaitaApp.copy("{define \(chord.define)}")
                                        copied.signal()
                                    }
                                    .flat(true)
                                }
                                Text(chord.notesLabel)
                                    .useMarkup()
                            }
                            .valign(.center)
                        }
                    }
                }
                HStack(spacing: 10) {
                    SwitchRow()
                        .title("Left-handed chords")
                        .active($settings.diagram.mirror)
                    HStack {
                        DropDown(
                            selection: $midiInstrument,
                            values: MidiUtils.Instrument.allCases
                        )
                    }
                    .valign(.center)

                }
            }
            .toast("Copied to clipboard", signal: copied)
            .topToolbar {
                HeaderBar { } end: {
                    SearchEntry()
                        .text($search)
                        .placeholderText("Search")
                }
                .headerBarTitle {
                    ViewSwitcher(selectedElement: $settings.instrument)
                        .wideDesign(true)
                }
            }
        }

        /// Get all filtered chords
        /// - Returns: The filtered chords
        private func getChords() -> [ChordDefinition] {
            var result = [ChordDefinition]()
            if search.isEmpty {
                result = ChordUtils.getAllChordsForInstrument(instrument: settings.instrument)
                    .filter { $0.root == chord }
                    .sorted(
                        using: [
                            KeyPathComparator(\.root), KeyPathComparator(\.slash), KeyPathComparator(\.quality)
                        ]
                    )
            } else {
                result = ChordUtils.getAllChordsForInstrument(instrument: settings.instrument)
                    .filter { $0.name.localizedCaseInsensitiveContains(search) }
                    .sorted(
                        using: [
                            KeyPathComparator(\.root), KeyPathComparator(\.slash), KeyPathComparator(\.quality)
                        ]
                    )
            }
            return result
        }
    }
}
