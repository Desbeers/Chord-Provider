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
        init(settings: AppSettings) {
            print("INIT")
            //self.chords = ChordUtils.getAllChordsForInstrument(instrument: .guitar)
            self.settings = settings
        }
        @State private var selection: Chord.Instrument = .guitar
        @State private var chords: [ChordDefinition] = []
        @State private var chord: Chord.Root.ID = ""
        let settings: AppSettings
        var view: Body {
            VStack {
                ToggleGroup(
                    selection: $chord,
                    values: Chord.Root.naturalAndSharp.dropFirst().dropLast()
                )
                ScrollView {
                    FlowBox(getChords(), selection: nil) { chord in
                        Text(chord.display)
                            .style(.chord)
                        Widgets.ChordDiagram(chord: chord, settings: settings)
                            .frame(minWidth: 100)
                            .frame(maxWidth: 100)
                    }
                }
                .vexpand()
            }
            .topToolbar {
                HeaderBar() { } end: { }
                    .headerBarTitle {
                        ViewSwitcher(selectedElement: $selection)
                            .wideDesign(true)
                    }
            }
        }

        func getChords() -> [ChordDefinition] {
            let chord = Chord.Root(rawValue: self.chord) ?? .c
            return ChordUtils.getAllChordsForInstrument(instrument: selection)
                .filter { $0.root == chord}
                .sorted(
                    using: [
                        KeyPathComparator(\.root), KeyPathComparator(\.slash), KeyPathComparator(\.quality)
                    ]
                )
        }
    }
}
