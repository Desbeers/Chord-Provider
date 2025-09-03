//
//  File.swift
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
        /// The body of the `View`
        var view: Body {
            Text("<span style='italic' foreground='\(HexColor.comment)'>\(comment)</span>")
                .wrap()
                .useMarkup()
                .padding()
                .halign(.start)
        }
    }
}
