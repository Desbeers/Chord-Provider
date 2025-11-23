//
//  GtkRender+EmptyLine.swift.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for an empty line
    struct EmptyLine: View {
        init() {
            print("EMPTYLINE INIT")
        }
        /// The body of the `View`
        var view: Body {
            Widgets.Empty()
                .padding(4)
        }
    }
}
