//
//  Widgets+ChordDiagram.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import ChordProviderCore

extension Widgets {

    /// The `AdwaitaWidget` for a chord diagram
    struct Diagram: AdwaitaWidget {
        /// The chord definition
        let chord: ChordDefinition
        /// The settings of the application
        let settings: ChordProviderSettings
        /// The width of the diagram
        let width: Double
        /// Init the `widget`
        public init(
            chord: ChordDefinition,
            width: Double = 100,
            settings: ChordProviderSettings
        ) {
            self.chord = chord
            self.settings = settings
            self.width = width
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
            let context = Context(definition: chord, showNotes: settings.diagram.showNotes)
            //convert(context: context)
            let drawingArea = gtk_drawing_area_new()
            gtk_drawing_area_set_content_width(drawingArea?.cast(), Int32(width))
            gtk_drawing_area_set_content_height(drawingArea?.cast(), Int32(width * 1.2))
            gtk_drawing_area_set_draw_func(
                drawingArea?.cast(),
                draw_chord,
                Unmanaged.passRetained(context).toOpaque()
            ) {
                userData in
                Unmanaged<Context>.fromOpaque(userData!).release()
            }
            let storage = ViewStorage(drawingArea?.opaque())
            return storage
        }
    }
}

/// Draw a chord diagram with *Cairo*
/// - Note: Declare C function implementations as `public` to ensure they're not optimized away.
@_cdecl("draw_chord")
public func draw_chord(
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

    let manager = adw_style_manager_get_default()
    let dark_mode = adw_style_manager_get_dark(manager)

    var drawnBarres = Set<Int>()

    let data = Unmanaged<Widgets.Diagram.Context>
        .fromOpaque(userData)
        .takeUnretainedValue()

    let color: Double = dark_mode == 0 ? 0 : 1
    let strings = data.definition.instrument.strings.count
    let width = Double(width)
    let height = Double(height)
    let margin: Double = width * 0.2
    let fretSpacing: Double = (height - 2 * margin) / 5.0
    let stringSpacing: Double = (width - 2 * margin) / Double(strings - 1)

    let radius = width * 0.06
    let degrees = G_PI / 180.0

    let fontSize = width * 0.08

    /// Set the font
    cairo_select_font_face(
        cr,
        "Adwaita Mono",
        cairo_font_slant_t(rawValue: 0),
        cairo_font_weight_t(rawValue: 0)
    )
    cairo_set_font_size(cr, fontSize)

    cairo_set_source_rgb(cr, color, color, color)
    cairo_set_line_width(cr, 0.2)

    /// Draw strings
    for index in 0..<strings {
        let x = margin + Double(index) * stringSpacing
        cairo_move_to(cr, x, margin)
        cairo_line_to(cr, x, height - margin)
    }
    cairo_stroke(cr)

    /// Draw top bar or base fret
    if data.definition.baseFret == .one {
        cairo_set_source_rgb(cr, color, color, color)
        cairo_set_line_width(cr, fontSize / 4)
        cairo_move_to(cr, margin - 1, margin)
        cairo_line_to(cr, width - margin + 1, margin)
        cairo_stroke(cr)
        cairo_set_line_width(cr, 0.2)
    } else {
        let xOffset = margin * (data.definition.baseFret.rawValue > 9 ? 0.2 : 0.4)
        cairo_set_source_rgb(cr, 0.5, 0.5, 0.5)
        cairo_move_to(cr, xOffset, margin + fretSpacing / 1.5)
        cairo_show_text(cr, "\(data.definition.baseFret.rawValue)")
    }

    /// Draw frets
    for index in 0..<6 {
        let y = margin + Double(index) * fretSpacing
        cairo_move_to(cr, margin, y)
        cairo_line_to(cr, width - margin, y)
    }
    cairo_stroke(cr)

    /// Draw finger positions
    for index in 0..<strings {
        let fret = data.definition.frets[index]
        let finger = data.definition.fingers[index]
        let x = margin + Double(index) * stringSpacing
        if fret == -1 {
            /// Muted string: draw X
            let xOffset = radius / 2
            cairo_set_source_rgb(cr, 0.5, 0.5, 0.5)
            cairo_move_to(cr, x - xOffset, margin - radius * 1.5)
            cairo_line_to(cr, x + xOffset, margin - xOffset)
            cairo_move_to(cr, x + xOffset, margin - radius * 1.5)
            cairo_line_to(cr, x - xOffset, margin - xOffset)
            cairo_set_line_width(cr, 1)
            cairo_stroke(cr)
        } else if fret == 0 {
            /// Open string: draw open circle
            cairo_set_source_rgb(cr, 0.5, 0.5, 0.5)
            cairo_arc(cr, x, margin - radius, radius / 2, 0, 2 * Double.pi)
            cairo_set_line_width(cr, 1)
            cairo_stroke(cr)
        } else if fret > 0 {
            if let barres = data.definition.barres, let barre = barres.first(where: { $0.fret == fret }), !drawnBarres.contains(barre.fret) {
                drawnBarres.insert(barre.fret)
                /// Draw barre
                let height = radius * 2
                let x = margin + (stringSpacing * Double(barre.startIndex)) - (stringSpacing / 2)
                let y = margin + Double(fret) * fretSpacing - fretSpacing + ((fretSpacing - height) / 2)
                let width = Double(barre.length) * stringSpacing

                cairo_new_sub_path(cr)
                cairo_arc(cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
                cairo_arc(cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
                cairo_arc(cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
                cairo_arc(cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
                cairo_close_path(cr)
                cairo_set_source_rgb(cr, 0.551, 0.551, 0.551)
                cairo_fill_preserve(cr)
                if finger > 0 {
                    cairo_move_to(cr, x + ((Double(barre.length) - 0.5) / 2 * stringSpacing), y + (fontSize / 0.9))
                    cairo_set_source_rgb(cr, 1, 1, 1)
                    cairo_show_text(cr, "\(finger)")
                    cairo_new_path(cr)
                }
            } else if !drawnBarres.contains(fret) {
                /// Finger position: draw filled circle
                let y = margin + Double(fret) * fretSpacing - fretSpacing / 2
                cairo_set_source_rgb(cr, 0.551, 0.551, 0.551)
                cairo_arc(cr, x, y, radius, 0, 2 * G_PI)
                cairo_fill_preserve(cr)
                if finger > 0 {
                    cairo_move_to(cr, x - (fontSize / 3.2), y + (fontSize / 2.4))
                    cairo_set_source_rgb(cr, 1, 1, 1)
                    cairo_show_text(cr, "\(finger)")
                    cairo_new_path(cr)
                }
            }
        }
        cairo_new_path(cr)
    }

    /// Draw notes

    if data.showNotes {
        cairo_set_source_rgb(cr, 0.5, 0.5, 0.5)
        for index in 0..<strings {
            let component = data.definition.components[index]
            var offset: Double = 0
            if let note = component.note != .none ? component.note : nil {
                offset = note.rawValue.count == 1 ? 1.1 : 1.25
            }
            let y = (margin / offset) + Double(index) * stringSpacing
            cairo_move_to(cr, y, height - fontSize * 1.4)
            let text = component.note != .none ? component.note.display : " "
            cairo_show_text(cr, text)
        }
    }
}
