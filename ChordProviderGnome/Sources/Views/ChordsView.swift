//
//  ChordsView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

/// The `View` for all the chords in a song
struct ChordsView: View {
    /// The ``song`` to view
    let song: Song
    /// The ``AppSettings``
    let settings: AppSettings
    /// The body of the `View`
    var view: Body {
        ScrollView {
            ForEach(song.chords) { chord in
                Text(chord.display)
                    .useMarkup()
                    .style(.chord)
                ChordDiagramView(chord: chord)
            }
        }
    }
}
