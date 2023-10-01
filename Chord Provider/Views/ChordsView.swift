//
//  ChordsView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the chord diagrams
struct ChordsView: View {
    /// The ``Song``
    let song: Song
    /// Chord Display Options
    @EnvironmentObject private var chordDisplayOptions: ChordDisplayOptions
    /// Sheet with chords
    @State var showChordSheet: ChordDefinition?
    /// The body of the `View`
    var body: some View {
        ScrollView {
            VStack {
                ForEach(song.chords.sorted(using: KeyPathComparator(\.name))) { chord in
                    switch chord.status {
                    case .standard, .transposed:
                        Button(
                            action: {
                                showChordSheet = chord
                            },
                            label: {
                                VStack(spacing: 0) {
                                    ChordDiagramView(chord: chord, width: 120)
                                }
                            }
                        )
                    default:
                        ChordDiagramView(chord: chord, width: 120)
                    }
                }
            }
            .padding()
        }
        .background(.thinMaterial)
        .animation(.default, value: song.chords)
        .buttonStyle(.plain)
        .sheet(item: $showChordSheet) { chord in
            Sheet(chord: chord)
        }
    }
}

extension ChordsView {

    /// View all chords of a certain key in a sheet
    struct Sheet: View {
        /// The presentation mode of the `Sheet`
        @Environment(\.dismiss) var dismiss
        /// The selected chord
        let chord: ChordDefinition
        /// All the chord variations
        @State private var chords: [ChordDefinition] = []
        /// The body of the `View`
        var body: some View {
            VStack {
                Text("Chord: \(chord.displayName(options: .init()))")
                    .font(.title)
                HStack {
                    ForEach(chord.quality.intervals.intervals, id: \.self) { interval in
                        Text(interval.description)
                    }
                }
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 140))],
                        alignment: .center,
                        spacing: 4,
                        pinnedViews: [.sectionHeaders, .sectionFooters]
                    ) {
                        ForEach(chords) { chord in
                            VStack {
                                ChordDiagramView(chord: chord, width: 140)
                            }
                        }
                    }
                }
                Button(
                    action: {
                        dismiss()
                    },
                    label: {
                        Text("Close")
                    }
                )
                .keyboardShortcut(.defaultAction)
            }
            .padding()
            .frame(minWidth: 600, idealWidth: 600, minHeight: 600, idealHeight: 600)
            .task {
                let allChords = Chords.getAllChordsForInstrument(instrument: chord.instrument)
                chords = allChords.matching(root: chord.root).matching(quality: chord.quality).matching(bass: chord.bass)
            }
        }
    }
}
