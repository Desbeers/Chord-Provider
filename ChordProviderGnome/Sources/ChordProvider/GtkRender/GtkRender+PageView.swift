//
//  GtkRender+PageView.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a whole song
    struct PageView: View {
        /// The state of the application
        let appState: AppState
        /// The body of the `View`
        var view: Body {
            VStack {
                switch appState.settings.app.columnPaging {
                case true:
                    PageHeader(appState: appState)
                    ScrollView {
                        sections
                    }
                    .vexpand()
                    .transition(.crossfade)
                case false:
                    ScrollView {
                        PageHeader(appState: appState)
                        sections
                    }
                    .vexpand()
                    .transition(.crossfade)
                }
            }
            .style("document")
            .hexpand()
        }
        /// The sections
        @ViewBuilder var sections: Body {
            GtkRender.SectionsView(appState: appState)
                .halign(.center)
                .padding(20)
        }
    }
}
