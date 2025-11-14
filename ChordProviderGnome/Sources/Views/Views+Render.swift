//
//  Views+Render.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

extension Views {

    /// The `View` for the rendered song
    struct Render: View {
        /// The whole song
        let song: Song
        /// The settings of the application
        let settings: AppSettings
        /// The body of the `View`
        var view: Body {
            HStack {
                GtkRender.PageView(song: song, settings: settings)
                Separator()
                if !song.chords.isEmpty {
                    Views.Chords(song: song, settings: settings)
                        .transition(.coverLeftRight)
                }
            }
            .padding(10, .top)
        }
    }
}
