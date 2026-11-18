//
//  Views+Main+Render.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita
import SourceEditor

extension Views.Main {

    /// The `View` for showing a rendered song
    struct Render: View {

        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            /// Show or hide the editor
            let binding = Binding(
                get: { appState.settings.showEditor ? appState.settings.splitter : 0 },
                set: { appState.settings.splitter = $0 }
            )
            HSplitView(splitter: binding) {
                Views.Editor(appState: $appState)
            } end: {
                if appState.song.hasContent {
                    VStack {
                        GtkRender.PageHeader(appState: $appState)
                        HStack {
                            VStack {
                                GtkRender.PageView(appState: $appState)
                            }
                            Separator()
                            VStack {
                                Views.Main.Chords(appState: $appState)
                            }
                        }
                        .hexpand()
                        .vexpand()
                    }
                } else {
                    Box {
                        switch appState.scene.viewStatus {
                        case .openingSong:
                            StatusPage(
                                "Loading",
                                icon: .default(icon: .folderMusic),
                                description: "Loading your song..."
                            )
                            .vexpand()
                        default:
                            StatusPage(
                                "No content",
                                icon: .default(icon: .folderMusic),
                                description: "The song has no content."
                            )
                            .vexpand()
                        }
                    }
                    .frame(minWidth: 350)
                    .transition(.crossfade)
                }
            }
        }
    }
}
