//
//  Views+Main.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Adwaita
import ChordProviderCore
import Foundation

extension Views {

    /// The main `View` for the application
    struct Main: View {
        /// The `AdwaitaApp`
        var app: AdwaitaApp
        /// The `AdwaitaWindow`
        var window: AdwaitaWindow
        /// The state of the application
        @Binding var appState: AppState
        /// The list of recent songs
        @Binding var recentSongs: RecentSongs

        // MARK: Main View

        /// The main `View`
        var view: Body {
            VStack {
                if appState.scene.showWelcomeView {
                    Views.Welcome(
                        app: app,
                        window: window,
                        appState: $appState,
                        recentSongs: $recentSongs
                    )
                    .vexpand()
                    .hexpand()
                    .transition(.crossfade)
                } else {
                    Views.Main.Render(appState: $appState)
                        .hexpand()
                        .vexpand()
                        .transition(.crossfade)
                        .topToolbar {
                            Toolbar.Main(
                                app: app,
                                window: window,
                                appState: $appState,
                                recentSongs: $recentSongs
                            )
                        }
                        .dialog(
                            visible: $appState.scene.showDebugDialog,
                            width: 800,
                            height: 600
                        ) {
                            Views.Debug(appState: $appState)
                        }
                }
                /// Add general dialogs
                dialogs
                /// Add dialogs for file handling
                importExportDialogs
            }

            // MARK: Toast

            /// The **Toast** message
            .toast(
                appState.scene.toastMessage.escapeSpecialCharacters,
                signal: appState.scene.showToast
            )
        }
    }
}
