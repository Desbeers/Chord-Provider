//
//  ChordsView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftyChords
import SwiftlyChordUtilities

/// SwiftUI `View` for the chord diagrams
struct ChordsView: View {
    /// The ``Song``
    let song: Song
    /// Size of the chord diagram
    let frame = CGRect(x: 0, y: 0, width: 100, height: 150)
    /// Sheet with chords
    @State var showChordSheet: Song.Chord?
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
                                    ChordDiagramView(chord: chord, playButton: true)
                                    Label(
                                        title: {
                                            Text("\(chord.getChordPostions().count) variations")
                                        },
                                        icon: {
                                            Image(systemName: "info.circle.fill")
                                        }
                                    )
                                    .font(.caption)
                                    .padding(.vertical, 4)
                                    .foregroundStyle(.secondary)
                                }
                            }
                        )
                    default:
                        ChordDiagramView(chord: chord)
                    }
                }
            }
            .padding()
        }
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
        let chord: Song.Chord
        /// The body of the `View`
        var body: some View {
            VStack {
                Text("Chord: \(chord.display)")
                    .font(.title)
#if os(macOS)
                MidiPlayer.InstrumentPicker()
#endif
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 110))],
                        alignment: .center,
                        spacing: 4,
                        pinnedViews: [.sectionHeaders, .sectionFooters]
                    ) {
                        ForEach(chord.getChordPostions()) { chord in
                            VStack {
                                let chordDiagram = Song.Chord(
                                    name: chord.name,
                                    chordPosition: chord,
                                    status: .standard
                                )
                                ChordDiagramView(chord: chordDiagram, playButton: true)
                            }

//                            let frame = CGRect(x: 0, y: 0, width: 120, height: 180)
//                            let layer = chord.chordLayer(rect: frame, showFingers: true)
//                            if let image = layer.image() {
//                                VStack {
//                                    Image(swiftImage: image)
//
//                                }
//                            }
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
            .frame(minWidth: 400, idealWidth: 600, minHeight: 400, idealHeight: 600)
        }
    }
}
