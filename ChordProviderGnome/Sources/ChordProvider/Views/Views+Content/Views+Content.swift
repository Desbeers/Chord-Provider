//
//  Views+Content.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The content `View` for the application
    struct Content: View {
        /// The `AdwaitaApp`
        var app: AdwaitaApp
        /// The `AdwaitaWindow`
        var window: AdwaitaWindow
        /// The state of the application
        @Binding var appState: AppState

        // MARK: Content View

        /// The content `View`
        var view: Body {
            VStack {
                if appState.scene.showWelcomeView {
                    Views.Welcome(app: app, window: window, appState: $appState)
                        .vexpand()
                        .hexpand()
                        .transition(.crossfade)
                } else {
                    Views.Render(appState: $appState)
                        .hexpand()
                        .vexpand()
                        .transition(.crossfade)
                        .topToolbar {
                            Views.Toolbar.Main(
                                app: app,
                                window: window,
                                appState: $appState
                            )
                        }
                        .dialog(visible: $appState.scene.showDebugDialog, width: 800, height: 600) {
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
            .toast(appState.scene.toastMessage.escapeSpecialCharacters(), signal: appState.scene.showToast)
        }
    }
}
