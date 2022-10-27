//
//  AllChordsView.swift
//  Chord Provider (macOS)
//
//  Created by Nick Berendsen on 26/10/2022.
//

import SwiftUI
import SwiftyChords

struct AllChordsView: View {
    let frame = CGRect(x: 0, y: 0, width: 100, height: 150)
    let allChords = SwiftyChords.Chords.guitar.sorted {
        $0.key.rawValue == $1.key.rawValue ? $0.suffix.rawValue < $1.suffix.rawValue : $0.key.rawValue < $1.key.rawValue
    }
    
    var body: some View {
        
        Table(allChords) {
            TableColumn("Diagram") { chord in
                diagram(chord: chord)
            }
            
            TableColumn("Chord") { chord in
                Text(chord.key.display.symbol + chord.suffix.display.symbolized)
            }
            TableColumn("Full") { chord in
                Text(chord.key.display.accessible + chord.suffix.display.accessible)
            }
            TableColumn("Base fret") { chord in
                Text(chord.baseFret.description)
            }
        }
    }

@ViewBuilder func diagram(chord: SwiftyChords.ChordPosition) -> some View {
    let layer = chord.chordLayer(rect: frame, showFingers: false)
    if let image = layer.image() {
#if os(macOS)
        Image(nsImage: image)
#endif
#if os(iOS)
        Image(uiImage: image)
#endif
    } else {
        Image(systemName: "music.note")
    }
}
}
