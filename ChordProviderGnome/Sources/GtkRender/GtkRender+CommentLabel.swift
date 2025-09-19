//
//  GtkRender+CommentLabel.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    struct CommentLabel: View {
        /// The comment
        let comment: String
        /// The settings
        let settings: AppSettings
        /// The body of the `View`
        var view: Body {
            Text(comment, font: .comment, zoom: settings.app.zoom)
                .wrap()
                .useMarkup()
                .padding()
                .halign(.start)
        }
    }
}
