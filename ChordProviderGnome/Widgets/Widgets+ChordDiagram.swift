//
//  Widgets+ChordDiagram.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import ChordProviderCore

extension Widgets {

    /// The `AdwaitaWidget` for a chord diagram
    struct ChordDiagram: AdwaitaWidget {
        /// The chord definition
        let chord: ChordDefinition
        /// The width of the diagram
        let width: Double
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The view storage.
        /// - Parameters:
        ///   - data: The widget data.
        ///   - type: The view render data type.
        /// - Returns: The view storage.
        func container<Data>(
            data: WidgetData,
            type: Data.Type
        ) -> ViewStorage where Data: ViewRenderData {
            let context = Context(definition: chord, showNotes: coreSettings.diagram.showNotes)
            let drawingArea = gtk_drawing_area_new()
            gtk_drawing_area_set_content_width(drawingArea?.cast(), Int32(width))
            let heightFactor = coreSettings.diagram.showNotes ? 1.2 : 1.1
            gtk_drawing_area_set_content_height(drawingArea?.cast(), Int32(width * heightFactor))
            gtk_drawing_area_set_draw_func(
                drawingArea?.cast(),
                draw_chord,
                Unmanaged.passRetained(context).toOpaque()
            ) { userData in
                if let userData {
                    Unmanaged<Context>.fromOpaque(userData).release()
                }
            }
            return ViewStorage(drawingArea?.opaque())
        }
    }
}

/// Draw a chord diagram with *Cairo*
@_documentation(visibility: private)
@_cdecl("draw_chord")
func draw_chord(
    _ area: UnsafeMutablePointer<GtkDrawingArea>?,
    _ currentState: OpaquePointer?,
    _ width: Int32,
    _ height: Int32,
    _ userData: UnsafeMutableRawPointer?
) {
    guard
        let currentState,
        let userData
    else { return }

    let manager = adw_style_manager_get_default()
    let darkMode = adw_style_manager_get_dark(manager) == 1 ? true : false

    var drawnBarres = Set<Int>()

    let data = Unmanaged<Widgets.ChordDiagram.Context>
        .fromOpaque(userData)
        .takeUnretainedValue()

    let color: Double = darkMode ? 1 : 0
    let dotColor: Double = darkMode ? 0.8 : 0.4
    let fingerColor: Double = darkMode ? 0 : 1
    let bgColor: Double = darkMode ? 0.8 : 0.4
    let strings = data.definition.instrument.strings.count
    let width = Double(width)
    let margin: Double = width * 0.2
    let fretSpacing: Double = ((width * 1.2) - 2 * margin) / 5.0
    let stringSpacing: Double = (width - 2 * margin) / Double(strings - 1)

    let radius = width * 0.06
    let degrees = G_PI / 180.0

    let fontSize = width * 0.08

    /// Set the font
    cairo_select_font_face(
        currentState,
        "Adwaita Mono",
        cairo_font_slant_t(rawValue: 0),
        cairo_font_weight_t(rawValue: 0)
    )
    cairo_set_font_size(currentState, fontSize)

    cairo_set_source_rgb(currentState, color, color, color)
    cairo_set_line_width(currentState, 0.2)

    /// Draw strings
    for index in 0..<strings {
        let x = margin + Double(index) * stringSpacing
        cairo_move_to(currentState, x, margin)
        cairo_line_to(currentState, x, (width * 1.2) - margin)
    }
    cairo_stroke(currentState)

    /// Draw top bar or base fret
    if data.definition.baseFret == .one {
        cairo_set_source_rgb(currentState, color, color, color)
        cairo_set_line_width(currentState, fontSize / 4)
        cairo_move_to(currentState, margin - 1, margin)
        cairo_line_to(currentState, width - margin + 1, margin)
        cairo_stroke(currentState)
        cairo_set_line_width(currentState, 0.2)
    } else {
        let xOffset = margin * (data.definition.baseFret.rawValue > 9 ? 0.2 : 0.4)
        cairo_set_source_rgb(currentState, bgColor, bgColor, bgColor)
        cairo_move_to(currentState, xOffset, margin + fretSpacing / 1.5)
        cairo_show_text(currentState, "\(data.definition.baseFret.rawValue)")
    }

    /// Draw frets
    for index in 0..<6 {
        let y = margin + Double(index) * fretSpacing
        cairo_move_to(currentState, margin, y)
        cairo_line_to(currentState, width - margin, y)
    }
    cairo_stroke(currentState)

    /// Draw finger positions
    for index in 0..<strings {
        let fret = data.definition.frets[index]
        let finger = data.definition.fingers[index]
        let x = margin + Double(index) * stringSpacing
        if fret == -1 {
            /// Muted string: draw X
            let xOffset = radius / 2
            cairo_set_source_rgb(currentState, bgColor, bgColor, bgColor)
            cairo_move_to(currentState, x - xOffset, margin - radius * 1.5)
            cairo_line_to(currentState, x + xOffset, margin - xOffset)
            cairo_move_to(currentState, x + xOffset, margin - radius * 1.5)
            cairo_line_to(currentState, x - xOffset, margin - xOffset)
            cairo_set_line_width(currentState, 1)
            cairo_stroke(currentState)
        } else if fret == 0 {
            /// Open string: draw open circle
            cairo_set_source_rgb(currentState, bgColor, bgColor, bgColor)
            cairo_arc(currentState, x, margin - radius, radius / 2, 0, 2 * Double.pi)
            cairo_set_line_width(currentState, 1)
            cairo_stroke(currentState)
        } else if fret > 0 {
            if let barres = data.definition.barres,
                let barre = barres.first(where: { $0.fret == fret }),
                !drawnBarres.contains(barre.fret) {
                /// Draw barre
                drawnBarres.insert(barre.fret)
                let height = radius * 2
                let x = margin + (stringSpacing * Double(barre.startIndex)) - (stringSpacing / 2)
                let y = margin + Double(fret) * fretSpacing - fretSpacing + ((fretSpacing - height) / 2)
                let width = Double(barre.length) * stringSpacing

                cairo_new_sub_path(currentState)
                cairo_arc(currentState, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
                cairo_arc(currentState, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
                cairo_arc(currentState, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
                cairo_arc(currentState, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
                cairo_close_path(currentState)
                cairo_set_source_rgb(currentState, dotColor, dotColor, dotColor)
                cairo_fill_preserve(currentState)
                if finger > 0 {
                    cairo_move_to(currentState, x + ((Double(barre.length) - 0.5) / 2 * stringSpacing), y + (fontSize / 0.9))
                    cairo_set_source_rgb(currentState, fingerColor, fingerColor, fingerColor)
                    cairo_show_text(currentState, "\(finger)")
                    cairo_new_path(currentState)
                }
            } else if !drawnBarres.contains(fret) {
                /// Finger position: draw filled circle
                let y = margin + Double(fret) * fretSpacing - fretSpacing / 2
                cairo_set_source_rgb(currentState, dotColor, dotColor, dotColor)
                cairo_arc(currentState, x, y, radius, 0, 2 * G_PI)
                cairo_fill_preserve(currentState)
                if finger > 0 {
                    cairo_move_to(currentState, x - (fontSize / 3.2), y + (fontSize / 2.4))
                    cairo_set_source_rgb(currentState, fingerColor, fingerColor, fingerColor)
                    cairo_show_text(currentState, "\(finger)")
                    cairo_new_path(currentState)
                }
            }
        }
        cairo_new_path(currentState)
    }

    /// Draw notes

    if data.showNotes {
        cairo_set_source_rgb(currentState, bgColor, bgColor, bgColor)
        for index in 0..<strings {
            let component = data.definition.components[index]
            var offset: Double = 0
            if let note = component.note != .unknown ? component.note : nil {
                offset = note.rawValue.count == 1 ? 1.1 : 1.25
            }
            let y = (margin / offset) + Double(index) * stringSpacing
            cairo_move_to(currentState, y, (width * 1.2) - fontSize * 1.4)
            let text = component.note != .unknown ? component.note.display : " "
            cairo_show_text(currentState, text)
        }
    }
}
