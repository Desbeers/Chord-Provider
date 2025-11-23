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

    /// The `View` for a comment label
    struct CommentLabel: View {
        /// Init the `View`
        init(comment: String, settings: AppSettings) {
            self.comment = Utils.convertSimpleLinks(comment)
            self.settings = settings
        }
        /// The comment as `String`
        let comment: String
        /// The settings of the application
        let settings: AppSettings
        /// The body of the `View`
        var view: Body {
            HStack(spacing: 10) {
                Symbol(icon: .default(icon: .userInvisible))
                Text(comment)
                    .useMarkup()
                    .wrap()
                    .halign(.start)
                /// This seems reasonable to me...
                    .frame(maxWidth: Int(400 * settings.app.zoom))
            }
            .style(.commentLabel)
            .halign(.start)
            .padding()
        }
    }
}
