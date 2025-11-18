//
//  GtkRender+PageView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a whole song
    struct PageView: View {
        /// The whole song
        let song: Song
        /// The settings of the application
        let settings: AppSettings
        /// The body of the `View`
        var view: Body {
            VStack {
                switch settings.app.columnPaging {
                case true:
                    PageHeader(song: song, settings: settings)
                    ScrollView {
                        sections
                    }
                    .vexpand()
                    .transition(.crossfade)
                case false:
                    ScrollView {
                        PageHeader(song: song, settings: settings)
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
            GtkRender.SectionsView(song: song, settings: settings)
                .halign(.center)
                .padding(20)
        }
    }
}
