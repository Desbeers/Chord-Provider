//
//  GtkRender+EmptyLine.swift.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita

extension GtkRender {

    /// The `View` for an empty line
    struct EmptyLine: View {
        /// The body of the `View`
        var view: Body {
            Views.Empty()
                .padding(4)
        }
    }
}
