//
//  Widgets+Arrow.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw

extension Widgets {

    /// The `AdwaitaWidget` for drawing an arrow
    struct Arrow: AdwaitaWidget {

        let direction: Direction
        let length: Int
        let dash: Bool

        /// Init the `widget`
        init(direction: Direction, length: Int = 40, dash: Bool) {
            self.direction = direction
            self.length = length
            self.dash = dash
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
            let context = Context(direction: direction, length: length, dash: dash)
            gtk_drawing_area_set_content_height(drawingArea?.cast(), Int32(length))
            gtk_drawing_area_set_draw_func(
                drawingArea?.cast(),
                draw_arrow,
                Unmanaged.passRetained(context).toOpaque()
            ) {
                userData in
                Unmanaged<Context>.fromOpaque(userData!).release()
            }
            let content: [String: [ViewStorage]] = [:]
            let storage = ViewStorage(drawingArea?.opaque(), content: content)
            return storage
        }

        /// The arrow direction
        enum Direction {
            /// Up
            case up
            /// Down
            case down
        }
    }
}

/// Draw an arrow with *Cairo*
/// - Note: Declare C function implementations as `public` to ensure they're not optimized away.
@_cdecl("draw_arrow")
public func draw_arrow(
    _ area: UnsafeMutablePointer<GtkDrawingArea>?,
    _ cr: OpaquePointer?,
    _ width: Int32,
    _ height: Int32,
    _ userData: UnsafeMutableRawPointer?
) {

    guard
        let cr,
        let userData
    else { return }

    let data = Unmanaged<Widgets.Arrow.Context>
        .fromOpaque(userData)
        .takeUnretainedValue()

    let manager = adw_style_manager_get_default()
    let dark_mode = adw_style_manager_get_dark(manager)

    let color: Double = dark_mode == 0 ? 0.5 : 0.8

    /// Arrowhead size
    let arrowLength = Double(data.length) / 4
    let arrowDegrees = Double.pi / 8

    let x1: Double = Double(data.length) / 5
    let y1: Double = data.direction == .down ? 0 : Double(data.length)
    let x2: Double = Double(data.length) / 5
    let y2: Double = data.direction == .down ? Double(data.length) : 0

    cairo_set_source_rgb(cr, color, color, color)
    cairo_set_line_width(cr, 1)

    /// Dashes for the line
    if data.dash {
        var dashes: [Double] = [4.0, 4.0]
        cairo_set_dash(cr, &dashes, Int32(dashes.count), 0)
    }

    /// Draw line
    cairo_move_to(cr, x1, y1)
    cairo_line_to(cr, x2, y2)
    cairo_stroke(cr)

    let  angle = atan2(y2 - y1, x2 - x1)

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
