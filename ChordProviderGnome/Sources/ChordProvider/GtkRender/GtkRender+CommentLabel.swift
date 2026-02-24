//
//  GtkRender+CommentLabel.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita

extension GtkRender {

    /// The `View` for a comment label
    struct CommentLabel: View {
        /// Init the `View`
        /// - Parameter comment: The comment as optional `String`
        init(comment: String?) {
            self.comment = Utils.convertSimpleLinks(comment ?? "Empty Comment")
        }
        /// The comment as `String`
        let comment: String
        /// The body of the `View`
        var view: Body {
            HStack(spacing: 10) {
                Symbol(icon: .default(icon: .userInvisible))
                Text(comment)
                    .useMarkup()
                    .wrap()
                    .halign(.start)
            }
            .style(.commentLabel)
            .card()
            .halign(.start)
            .padding()
        }
    }
}
