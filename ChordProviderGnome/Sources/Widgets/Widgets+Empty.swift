//
//  Widgets+Empty.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Adwaita
import CAdw

extension Widgets {

    /// A `AdwaitaWidget` that shows nothing
    struct Empty: AdwaitaWidget {

        /// The view storage.
        /// - Parameters:
        ///     - data: The widget data.
        ///     - type: The view render data type.
        /// - Returns: The view storage.
        func container<Data>(
            data: WidgetData,
            type: Data.Type
        ) -> ViewStorage where Data: ViewRenderData {
            let drawingArea = gtk_drawing_area_new()
            let content: [String: [ViewStorage]] = [:]
            let storage = ViewStorage(drawingArea?.opaque(), content: content)
            return storage
        }

        func update<Data>(
            _ storage: ViewStorage,
            data: WidgetData,
            updateProperties: Bool,
            type: Data.Type
        ) where Data: ViewRenderData {
            /// Nothing to do
        }
    }
}
