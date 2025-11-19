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
        /// The app
        let app: AdwaitaApp
        /// The window
        let window: AdwaitaWindow
        /// The whole song
        @Binding var song: Song
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            EitherView(appState.settings.editor.showEditor) {
                HSplitView(splitter: $appState.settings.editor.splitter) {
                    Views.Editor(app: app, song: song, appState: $appState)
                } end: {
                    render
                }
            } else: {
                render
            }
            
            // MARK: Top Toolbar

            .topToolbar {
                Views.Toolbar.Main(
                    app: app,
                    window: window,
                    appState: $appState
                )
            }

            // MARK: On Update

            .onUpdate {
                /// Update the song when its contents is changed or when the core settings are changed
                if appState.scene.source != song.content || song.settings != appState.settings.core {
                    Idle {
                        LogUtils.shared.clearLog()
                        song.content = appState.scene.source
                        song = ChordProParser.parse(
                            song: song,
                            settings: appState.settings.core
                        )
                    }
                }
            }
        }

        @ViewBuilder
        var render: Body {
            HStack {
                GtkRender.PageView(song: song, settings: appState.settings)
                Separator()
                Views.Chords(song: song, appState: $appState)
            }
                .hexpand()
                .vexpand()
                .transition(.crossfade)
        }
    }
}
