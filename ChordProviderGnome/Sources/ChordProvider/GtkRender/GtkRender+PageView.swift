//
//  GtkRender+PageView.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import CAdw

extension GtkRender {

    /// The `View` for a whole song
    struct PageView: View {
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            VStack {
                switch appState.settings.app.columnPaging {
                case true:
                    PageHeader(appState: $appState)
                    ScrollView {
                        sections
                    }
                    .vexpand()
                    .transition(.crossfade)
                case false:
                    ScrollView {
                        PageHeader(appState: $appState)
                        sections
                    }
                    .vexpand()
                    .transition(.crossfade)
                }
            }
            .hexpand()
            .inspectOnAppear { storage in

                // MARK: Pinch to Zoom

                let gesture = gtk_gesture_zoom_new()
                var zoomStart = appState.settings.theme.zoom
                /// *begin* signal
                storage.connectSignal(name: "begin", argCount: 1, pointer: gesture) { _ in
                    zoomStart = appState.settings.theme.zoom
                }
                /// *scale-changed* signal
                storage.connectSignal(name: "scale-changed", pointer: gesture) {
                    let delta = gtk_gesture_zoom_get_scale_delta(gesture)
                    let newZoom = zoomStart * delta
                    let step: Double = 0.05
                    let stepped = (newZoom / step).rounded() * step
                    if stepped != appState.settings.theme.zoom {
                        Idle {
                            appState.settings.theme.zoom = min(max(stepped, 0.5), 2.0)
                        }
                    }
                }
                gtk_widget_add_controller(storage.opaquePointer?.cast(), gesture)
            }
        }
        /// The sections
        @ViewBuilder var sections: Body {
            GtkRender.SectionsView(appState: appState)
                .halign(.center)
                .padding(20)
        }
    }
}
