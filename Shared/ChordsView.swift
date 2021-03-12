//  MARK: - View: Chords View for macOS and iOS

/// Show chord diagrams

import SwiftUI
import GuitarChords

struct ChordsView: View {
    @ObservedObject var song: Song
    let frame = CGRect(x: 0, y: 0, width: 100, height: 150)
    /// Get all chord diagrams
    static let chordsDatabase = GuitarChords.all
    
    var body: some View {
        ScrollView() {
            VStack() {
                ForEach(song.chords.sorted { $0.name < $1.name }) { chord in
                    Text(chord.name).foregroundColor(.accentColor).font(.title2)
                    if let chordPosition = ChordsView.chordsDatabase.filter { $0.key == chord.key && $0.suffix == chord.suffix && $0.baseFret == chord.basefret} {
                        let layer = chordPosition.first!.layer(rect: frame, showFingers: true, showChordName: false, forScreen: true)
                        let image = layer.image()
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
            .padding(.trailing)
        }
    }
}
