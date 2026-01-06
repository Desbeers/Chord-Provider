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
                    Views.Editor(appState: $appState)
                } end: {
                    if appState.editor.song.hasContent {
                        HStack {
                            GtkRender.PageView(song: appState.editor.song, settings: appState.settings)
                            Separator()
                            Views.Chords(song: appState.editor.song, appState: $appState)
                        }
                        .hexpand()
                        .vexpand()
                    } else {
                        StatusPage(
                            "Loading",
                            icon: .default(icon: .folderMusic),
                            description: "Loading your song..."
                        )
                        .frame(minWidth: 350)
                        .transition(.crossfade)
                    }
                }
            }
            /// Set the ID to the View with the unique ID of the song
            .id(appState.editor.song.id)
        }
    }
}
