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
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            HStack {
                GtkRender.PageView(song: song, settings: appState.settings)
                Separator()
                Views.Chords(song: song, appState: $appState)
            }
        }
    }
}
