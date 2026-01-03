//
//  Views+Render.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension Views {

    /// The `View` for showing a rendered song
    struct Render: View {
        /// The whole song
        let song: Song
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            /// Show or hide the editor
            let binding = Binding(
                get: { self.appState.settings.editor.showEditor ? appState.settings.editor.splitter : 0 },
                set: { self.appState.settings.editor.splitter = $0 }
            )
            VStack {
                HSplitView(
                    splitter: binding
                ) {
                    Views.Editor(appState: $appState, song: song)
                } end: {
                    HStack {
                        GtkRender.PageView(song: song, settings: appState.settings)
                        Separator()
                        Views.Chords(song: song, appState: $appState)
                    }
                    .hexpand()
                    .vexpand()
                }
            }
            .id(appState.scene.id)
        }
    }
}
