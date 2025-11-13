//
//  Views+Chords.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` for all the chords in a song
    struct Chords: View {
        /// The whole song
        let song: Song
        /// The settings of the application
        let settings: AppSettings
        /// The body of the `View`
        var view: Body {
            ScrollView {
                ForEach(song.chords) { chord in
                    Text(chord.display)
                        .style(.chord)
                    Widgets.ChordDiagram(chord: chord)
                }
            }
        }
    }
}
