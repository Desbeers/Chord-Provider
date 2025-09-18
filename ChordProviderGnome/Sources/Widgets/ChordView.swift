//
//  File.swift
//  ChordProvider
//
//  Created by Nick Berendsen on 02/09/2025.
//

import Foundation
import Adwaita
import CAdw
import CChordProvider
import ChordProviderCore

public struct ChordView: AdwaitaWidget {

    let chord: ChordDefinition

    /// The start content's id.
    let chordID = "chord"

    let cchord = UnsafeMutablePointer<ChordInC>.allocate(capacity: 1)

    public init(
        chord: ChordDefinition
    ) {
        self.chord = chord
    }

    /// The view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        let drawingArea = gtk_drawing_area_new()

        gtk_drawing_area_set_content_width(drawingArea?.cast(), 120)
        gtk_drawing_area_set_content_height(drawingArea?.cast(), 140)

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
        cchord.pointee.strings = Int32(chord.instrument.strings.count)
        cchord.pointee.frets = (
            Int32(chord.frets[safe: 0] ?? 0),
            Int32(chord.frets[safe: 1] ?? 0),
            Int32(chord.frets[safe: 2] ?? 0),
            Int32(chord.frets[safe: 3] ?? 0),
            Int32(chord.frets[safe: 4] ?? 0),
            Int32(chord.frets[safe: 5] ?? 0)
        )
        gtk_drawing_area_set_draw_func(storage.opaquePointer?.cast(), draw_chord, cchord, nil)
    }
}

@_cdecl("chordiagram_draw")
func chordiagram_draw(
    ptr: UnsafeMutableRawPointer,
    file: UnsafePointer<CChar>?,
    userData: UnsafeMutableRawPointer
) {

}
