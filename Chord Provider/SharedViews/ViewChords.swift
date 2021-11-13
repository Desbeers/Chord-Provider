// MARK: - View: Chords View for macOS and iOS

/// Show chord diagrams

import SwiftUI
import GuitarChords

struct ViewChords: View {
    @ObservedObject var song: Song
    let frame = CGRect(x: 0, y: 0, width: 100, height: 150)
    /// Get all chord diagrams
    static let chordsDatabase = GuitarChords.all
    /// Sheet with chords
    @State var showChordSheet = false
    @State var selectedChord: Chord?
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(song.chords.sorted { $0.name < $1.name }) { chord in
                    Group {
                        Text(chord.name).foregroundColor(.accentColor).font(.title2)
                        if let chordPosition = ViewChords.chordsDatabase.filter { $0.key == chord.key && $0.suffix == chord.suffix && $0.baseFret == chord.basefret} {
                            let layer = chordPosition.first?.layer(rect: frame, showFingers: true, showChordName: false, forScreen: true)
                            let image = layer?.image()
                            #if os(macOS)
                            Image(nsImage: (image ?? NSImage(named: "AppIcon"))!)
                                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                            #endif
                            #if os(iOS)
                            Image(uiImage: (image ?? UIImage(named: "AppIcon"))!)
                            #endif
                        }
                    }
                    .onTapGesture {
                        selectedChord = chord
                        showChordSheet = true
                    }
                }
            }
            .padding(.trailing)
        }
        .sheet(isPresented: $showChordSheet) {
            ChordsSheet(chord: $selectedChord)
        }
    }
}

struct ChordsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var chord: Chord?
    var body: some View {
        let chordPosition = GuitarChords.all.matching(key: chord!.key).matching(suffix: chord!.suffix)
        VStack {
            Text("Chord: \(chord!.key.rawValue)\(chord!.suffix.rawValue)")
                .font(.title)
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 110))],
                    alignment: .center,
                    spacing: 4,
                    pinnedViews: [.sectionHeaders, .sectionFooters]
                ) {
                    ForEach(chordPosition) { chord in
                        let frame = CGRect(x: 0, y: 0, width: 120, height: 180) // I find these sizes to be good.
                        let layer = chord.layer(rect: frame, showFingers: true, showChordName: false, forScreen: true)
                        let image = layer.image() // might be exepensive. Use CALayer when possible.
                        #if os(macOS)
                        Image(nsImage: image!)
                            .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                        #endif
                        #if os(iOS)
                        Image(uiImage: image!)
                        #endif
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
        .frame(minWidth: 400, idealWidth: 400, minHeight: 400, idealHeight: 400)
    }
}
