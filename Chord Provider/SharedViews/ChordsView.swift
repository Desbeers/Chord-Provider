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
    @State var showChordSheet = false
    /// The optional selected chord to show in the `Sheet`
    @State var selectedChord: Song.Chord?
    /// The body of the `View`
    var body: some View {
        ScrollView {
            VStack {
                ForEach(song.chords.sorted(using: KeyPathComparator(\.name))) { chord in
                    Group {
                        HStack(alignment: .top, spacing: 0) {
                            Text("\(chord.display)")
                                .foregroundColor(.accentColor)
                                .font(.title2)
                        }

                        if chord.isCustom && song.transpose != 0 {
                            VStack {
                                Image(systemName: "music.note")
                                Text("Custom chords cannot transpose to its new shape")
                                    .font(.caption)
                            }
                            .padding(4)
                            .frame(width: 100, height: 120, alignment: .center)
                            .border(.primary)
                        } else {
                            let showFingers = !chord.chordPosition
                                .fingers
                                .dropFirst()
                                .allSatisfy { $0 == chord.chordPosition.fingers.first }
                            let layer = chord.chordPosition.chordLayer(
                                rect: frame,
                                showFingers: showFingers,
                                chordName: .init(show: false)
                            )
                            if let image = layer.image() {
                                Image(swiftImage: image)
                            } else {
                                VStack {
                                    Image(systemName: "music.note")
                                    Text("Unknown chord")
                                }
                                .frame(width: 100, alignment: .center)
                                .padding(4)
                                .border(.primary)
                            }
                        }
                    }
                    .onTapGesture {
                        /// Only show a sheet if the chord is not custom defined
                        if !chord.isCustom {
                            selectedChord = chord
                            showChordSheet = true
                        }
                    }
                }
            }
            .padding(.top)
            .padding(.trailing)
        }
        .sheet(isPresented: $showChordSheet) {
            Sheet(chord: $selectedChord)
        }
    }
}

extension ChordsView {

    /// View all chords of a certain key in a sheet
    struct Sheet: View {
        /// The presentation mode of the `Sheet`
        @Environment(\.presentationMode)
        var presentationMode
        /// The selected chord
        @Binding var chord: Song.Chord?
        /// The body of the `View`
        var body: some View {
            if let chord {
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
                                let frame = CGRect(x: 0, y: 0, width: 120, height: 180)
                                let layer = chord.chordLayer(rect: frame, showFingers: true)
                                if let image = layer.image() {
                                    VStack {
                                        Image(swiftImage: image)
#if os(macOS)
                                        MidiPlayer.PlayButton(chord: chord)
#endif
                                    }
                                }
                            }
                        }
                    }
                    Button(
                        action: {
                            presentationMode.wrappedValue.dismiss()
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
}
