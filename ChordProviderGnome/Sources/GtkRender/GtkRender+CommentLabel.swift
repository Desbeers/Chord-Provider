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
            HStack(spacing: 10) {
                Symbol(icon: .default(icon: .userInvisible))
                Text(comment)
                    .useMarkup()
                    .wrap()
            }
            .style(Markup.Class.commentLabel.description)
            .padding()
            .halign(.start)
        }
    }
}
