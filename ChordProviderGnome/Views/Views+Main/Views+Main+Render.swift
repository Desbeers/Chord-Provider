//
//  Views+Main+Render.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension Views.Main {

    /// The `View` for showing a rendered song
    struct Render: View {
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            /// Show or hide the editor
            let binding = Binding(
                get: { appState.settings.editor.showEditor ? appState.settings.editor.splitter : 0 },
                set: { appState.settings.editor.splitter = $0 }
            )
            HSplitView(splitter: binding) {
                Views.Editor(appState: $appState)
            } end: {
                if appState.editor.song.hasContent {
                    VStack {
                        GtkRender.PageHeader(appState: $appState)
                        HStack {
                            GtkRender.PageView(appState: $appState)
                            Separator()
                            Views.Main.Chords(appState: $appState)
                        }
                        .hexpand()
                        .vexpand()
                    }
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
    }
}
