//
//  Views+Database.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` for showing the chord database
    struct Database: View {
        /// The settings of the application
        let settings: AppSettings
        /// The selected instrument
        @State private var instrument: Chord.Instrument = .guitar
        /// The selected chord
        @State private var chord: Chord.Root.ID = "C"
        /// The optional search string
        @State private var search: String = ""
        /// The current selected diagram
        @State private var selection: UUID = UUID()
        /// Toast signal when a definition is copied
        @State private var copied: Signal = .init()
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
                                Text(chord.display)
                                    .style(.chord)
                                Widgets.ChordDiagram(chord: chord, settings: settings)
                            }
                        }
                        .valign(.start)
                        .padding()
                    }
                }
                .vexpand()
                if let chord = chords.first(where: { $0.id == selection }) {
                    Separator()
                    HStack {
                        Widgets.ChordDiagram(chord: chord, width: 140, settings: settings)
                        VStack {
                            Text(chord.display)
                                .style(.title)
                            Text(chord.quality.intervalsLabel)
                                .style(.subtitle)
                            HStack {
                                Text("{define \(chord.define)}")
                                    .selectable()
                                Button(icon: .default(icon: .editCopy)) {
                                    AdwaitaApp.copy("{define \(chord.define)}")
                                    copied.signal()
                                }
                                .flat(true)
                            }
                        }
                        .padding()
                    }
                }
            }
            .toast("Copied to clipboard", signal: copied)
            .topToolbar {
                HeaderBar() { } end: {
                    SearchEntry()
                        .text($search)
                        .placeholderText("Search")
                }
                .headerBarTitle {
                    ViewSwitcher(selectedElement: $instrument)
                        .wideDesign(true)
                }
            }
        }
        
        /// Get all filtered chords
        /// - Returns: The filtered chords
        private func getChords() -> [ChordDefinition] {
            if search.isEmpty {
                let chord = Chord.Root(rawValue: self.chord) ?? .c
                return ChordUtils.getAllChordsForInstrument(instrument: instrument)
                    .filter { $0.root == chord}
                    .sorted(
                        using: [
                            KeyPathComparator(\.root), KeyPathComparator(\.slash), KeyPathComparator(\.quality)
                        ]
                    )
            } else {
                return ChordUtils.getAllChordsForInstrument(instrument: instrument)
                    .filter { $0.name.localizedCaseInsensitiveContains(search) }
                    .sorted(
                        using: [
                            KeyPathComparator(\.root), KeyPathComparator(\.slash), KeyPathComparator(\.quality)
                        ]
                    )
            }
        }
    }
}
