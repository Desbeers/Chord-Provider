//
//  Widgets+Arrow.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CChordProvider

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

            let cdata = UnsafeMutablePointer<cstrum>.allocate(capacity: 1)
            cdata.initialize(
                to: cstrum(
                    down: direction == .down,
                    dash: dash,
                    length: Int32(length)
                )
            )
            gtk_drawing_area_set_content_height(drawingArea?.cast(), cdata.pointee.length)
            gtk_drawing_area_set_draw_func(drawingArea?.cast(), draw_arrow, cdata) { userData in
                userData?
                    .assumingMemoryBound(to: cstrum.self)
                    .deinitialize(count: 1)
                userData?
                    .assumingMemoryBound(to: cstrum.self)
                    .deallocate()
            }
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
            if updateProperties {
                Idle {
                    gtk_widget_queue_draw(storage.opaquePointer?.cast())
                }
            }
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

/// Draw a chord diagram with *Cairo*
///
/// - Note: Declare C function implementations as `public` to ensure they're not optimized away.
@_cdecl("draw_arrow_swift")
public func drawArrow(
    cr: OpaquePointer,
    width: Int32,
    height: Int32,
    user_data: gpointer,
    dark_mode: gboolean
) {
    let data = user_data
        .assumingMemoryBound(to: cstrum.self)
        .pointee

    let color: Double = dark_mode == 0 ? 0.5 : 0.8

    /// Arrowhead size
    let arrowLength = Double(data.length) / 4
    let arrowDegrees = Double.pi / 8

    let x1: Double = Double(data.length) / 5
    let y1: Double = data.down ? 0 : Double(data.length)
    let x2: Double = Double(data.length) / 5
    let y2: Double = data.down ? Double(data.length) : 0

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
