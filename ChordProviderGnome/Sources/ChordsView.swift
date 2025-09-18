//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

struct ChordsView: View {

    let song: Song
    let settings: AppSettings

    var view: Body {
        ScrollView {
            ForEach(song.chords) { chord in
                Text(chord.display, font: .chord, zoom: 1)
                    .useMarkup()
                ChordView(chord: chord)
            }
        }
    }
}
