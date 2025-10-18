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

/// The `AdwaitaWidget` for an arrow
struct ArrowView: AdwaitaWidget {

    let cstrum = UnsafeMutablePointer<cstrum>.allocate(capacity: 1)

    /// Init the `widget`
    init(direction: Direction, length: Int = 40, dash: Bool) {

        cstrum.pointee.down = direction == .down ? true : false
        cstrum.pointee.dash = dash
        cstrum.pointee.length = Int32(length)

        //self.direction.initialize(to: direction == .down ? true : false)
    }
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
        gtk_drawing_area_set_content_height(drawingArea?.cast(), cstrum.pointee.length)
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
        gtk_drawing_area_set_draw_func(storage.opaquePointer?.cast(), draw_arrow, cstrum, nil)
    }
}

extension ArrowView {

    enum Direction {
        case up
        case down
    }
}

/// Draw a chord diagram with *Cairo*
///
/// - Note: Declare C function implementations as `public` to ensure they're not optimized away.
@_cdecl("draw_arrow_swift")
public func drawArrow(
    cr: OpaquePointer!,
    width: Int32,
    height: Int32,
    user_data: gpointer!,
    dark_mode: gboolean
) {
    let data = user_data.load(as: cstrum.self)

    let color: Double = dark_mode == 0 ? 0.5 : 0.8

    /// Arrowhead size
    let arrowLength = Double(data.length) / 4
    let arrowDegrees = Double.pi / 8

    let x1: Double = Double(data.length) / 5
    let y1: Double = data.down == true ? 0 : Double(data.length)
    let x2: Double = Double(data.length) / 5
    let y2: Double = data.down == true ? Double(data.length) : 0

    cairo_set_source_rgb(cr, color, color, color)
    cairo_set_line_width(cr, 1)

    /// Dashes for the line
    if data.dash {
        cairo_set_dash(cr, [4, 0], 1, 0)
    }

    /// Draw line
    cairo_move_to(cr, x1, y1)
    cairo_line_to(cr, x2, y2)
    cairo_stroke(cr)

    let  angle = atan2(y2 - y1, x2 - x1);

    /// Calculate the two points for the arrowhead
    let  x3 = x2 - arrowLength * cos(angle - arrowDegrees)
    let  y3 = y2 - arrowLength * sin(angle - arrowDegrees)
    let  x4 = x2 - arrowLength * cos(angle + arrowDegrees)
    let  y4 = y2 - arrowLength * sin(angle + arrowDegrees)

    /// Draw arrowhead
    cairo_move_to(cr, x2, y2)
    cairo_line_to(cr, x3, y3)
    cairo_line_to(cr, x4, y4)
    cairo_close_path(cr)
    cairo_fill(cr)
}
