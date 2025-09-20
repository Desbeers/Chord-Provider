//
//  ChordDiagramView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CChordProvider
import ChordProviderCore

/// The `AdwaitaWidget` for a chord diagram
public struct ChordDiagramView: AdwaitaWidget {
    /// The `C` version of the chord definition
    let cchord = UnsafeMutablePointer<cchord>.allocate(capacity: 1)
    /// Init the `widget`
    public init(
        chord: ChordDefinition
    ) {
        cchord.pointee.strings = Int32(chord.instrument.strings.count)
        cchord.pointee.base_fret = Int32(chord.baseFret)
        cchord.pointee.frets = (
            Int32(chord.frets[safe: 0] ?? 0),
            Int32(chord.frets[safe: 1] ?? 0),
            Int32(chord.frets[safe: 2] ?? 0),
            Int32(chord.frets[safe: 3] ?? 0),
            Int32(chord.frets[safe: 4] ?? 0),
            Int32(chord.frets[safe: 5] ?? 0)
        )
        cchord.pointee.fingers = (
            Int32(chord.fingers[safe: 0] ?? 0),
            Int32(chord.fingers[safe: 1] ?? 0),
            Int32(chord.fingers[safe: 2] ?? 0),
            Int32(chord.fingers[safe: 3] ?? 0),
            Int32(chord.fingers[safe: 4] ?? 0),
            Int32(chord.fingers[safe: 5] ?? 0)
        )
    }
    /// The view storage.
    /// - Parameters:
    ///     - data: The widget data.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        let drawingArea = gtk_drawing_area_new()
        gtk_drawing_area_set_content_height(drawingArea?.cast(), 120)
        let content: [String: [ViewStorage]] = [:]
        let storage = ViewStorage(drawingArea?.opaque(), content: content)
        return storage
    }

    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        gtk_drawing_area_set_draw_func(storage.opaquePointer?.cast(), draw_chord, cchord, nil)
    }
}
