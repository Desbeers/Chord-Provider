//
//  Widgets+ChordDiagram.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CChordProvider
import ChordProviderCore

extension Widgets {

    /// The `AdwaitaWidget` for a chord diagram
    struct ChordDiagram: AdwaitaWidget {
        /// The `C` version of the chord definition
        let cchord = UnsafeMutablePointer<cchord>.allocate(capacity: 1)
        /// Init the `widget`
        public init(
            chord: ChordDefinition,
            settings: AppSettings
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
            if let barres = chord.barres {
                var result: [cbarre] = []
                for barre in barres {
                    let item = cbarre(
                        finger: Int32(barre.finger),
                        fret: Int32(barre.fret),
                        start_index: Int32(barre.startIndex),
                        end_index: Int32(barre.endIndex)
                    )
                    result.append(item)
                }
                cchord.pointee.barre = (
                    result[safe: 0] ?? cbarre(),
                    result[safe: 1] ?? cbarre(),
                    result[safe: 2] ?? cbarre(),
                    result[safe: 3] ?? cbarre(),
                    result[safe: 4] ?? cbarre()
                )
            }
            cchord.pointee.show_notes = settings.core.diagram.showNotes
            var result: [cnote] = []
            for note in chord.components {
                let string = note.note == .none ? " " : note.note.display
                if let pointer: UnsafeMutablePointer<CChar> = strdup(NSString(string: string).utf8String) {
                    result.append(cnote(note: pointer))
                }
            }
            cchord.pointee.note = (
                result[safe: 0] ?? cnote(),
                result[safe: 1] ?? cnote(),
                result[safe: 2] ?? cnote(),
                result[safe: 3] ?? cnote(),
                result[safe: 4] ?? cnote(),
                result[safe: 5] ?? cnote()
            )
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
            gtk_drawing_area_set_content_height(drawingArea?.cast(), 120)
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
            gtk_drawing_area_set_draw_func(storage.opaquePointer?.cast(), draw_chord, cchord, nil)
        }
    }
}

/// Draw a chord diagram with *Cairo*
///
/// - Note: Declare C function implementations as `public` to ensure they're not optimized away.
@_cdecl("draw_chord_swift")
public func drawChord(
    cr: OpaquePointer!,
    width: Int32,
    height: Int32,
    user_data: gpointer!,
    dark_mode: gboolean
) {
    let data = user_data.load(as: cchord.self)

    let color: Double = dark_mode == 0 ? 0 : 1

    let strings: Int = Int(data.strings)
    let width = Double(width)
    let height = Double(height)

    let frets = Mirror(reflecting: data.frets).children.map { item in
        return Int("\(item.value)") ?? 0
    }

    let fingers = Mirror(reflecting: data.fingers).children.map { item in
        return Int("\(item.value)") ?? 0
    }

    let notes = Mirror(reflecting: data.note).children.map { item in
        let note = item.value as! cnote
        return String(cString: note.note)
    }

    let barres: [Chord.Barre] = Mirror(reflecting: data.barre).children.map { item in
        if let barre = item.value as? cbarre {
            return Chord.Barre(
                finger: Int(barre.finger),
                fret: Int(barre.fret),
                startIndex: Int(barre.start_index),
                endIndex: Int(barre.end_index)
            )
        }
        return Chord.Barre()
    }
    let margin: Double = 20
    let fretSpacing: Double = (height - 2 * margin) / 5.0
    let stringSpacing: Double = (width - 2 * margin) / Double(strings - 1)

    let radius = 6.0
    let degrees = G_PI / 180.0

    /// Set the font
    cairo_select_font_face(
        cr, "Adwaita Mono",
        cairo_font_slant_t(rawValue: 0),
        cairo_font_weight_t(rawValue: 0)
    )
    cairo_set_font_size(cr, 8)

    cairo_set_source_rgb(cr, color, color, color)
    cairo_set_line_width(cr, 0.2)

    /// Draw strings
    for i in 0..<strings {
        let x = margin + Double(i) * stringSpacing
        cairo_move_to(cr, x, margin)
        cairo_line_to(cr, x, height - margin)
    }
    cairo_stroke(cr);

    /// Draw top bar or base fret
    if (data.base_fret == 1) {
        cairo_set_source_rgb(cr, color, color, color)
        cairo_set_line_width(cr, 2)
        cairo_move_to(cr, margin - 1, margin)
        cairo_line_to(cr, width - margin + 1, margin)
        cairo_stroke(cr)
        cairo_set_line_width(cr, 0.2)
    } else {
        cairo_set_source_rgb(cr, 0.5, 0.5, 0.5)
        cairo_move_to(cr, margin - 15, margin + fretSpacing / 1.5)
        cairo_show_text(cr, "\(data.base_fret)")
    }

    /// Draw frets
    for i in 0..<6 {
        let y = margin + Double(i) * fretSpacing
        cairo_move_to(cr, margin, y)
        cairo_line_to(cr, width - margin, y)
    }
    cairo_stroke(cr);

    /// Draw finger positions
    for i in 0..<strings {
        let x = margin + Double(i) * stringSpacing
        if (frets[i] == -1) {
            /// Muted string: draw X
            cairo_set_source_rgb(cr, 0.5, 0.5, 0.5)
            cairo_move_to(cr, x - 3, margin - 11)
            cairo_line_to(cr, x + 3, margin - 5)
            cairo_move_to(cr, x + 3, margin - 11)
            cairo_line_to(cr, x - 3, margin - 5)
            cairo_set_line_width(cr, 1)
            cairo_stroke(cr);
        } else if frets[i] == 0 {
            /// Open string: draw open circle
            cairo_set_source_rgb(cr, 0.5, 0.5, 0.5)
            cairo_arc(cr, x, margin - 8, 3, 0, 2 * Double.pi)
            cairo_set_line_width(cr, 1)
            cairo_stroke(cr)
        } else if frets[i] > 0 {

            if let barre = barres.first(where: {$0.fret == frets[i]}) {
                /// Draw barre
                let x = margin + (stringSpacing * Double(barre.startIndex)) - (stringSpacing / 2)
                let y = margin + Double(frets[i]) * fretSpacing - fretSpacing + 3

                let width = Double(barre.length) * stringSpacing
                let height = 10.0

                cairo_new_sub_path (cr)
                cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
                cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
                cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
                cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
                cairo_close_path (cr)
                cairo_set_source_rgb(cr, 0.551, 0.551, 0.551)
                cairo_fill_preserve (cr)
                if (fingers[i] > 0) {
                    cairo_move_to(cr, x + ((Double(barre.length) - 0.5) / 2 * stringSpacing), y + 8)
                    cairo_set_source_rgb(cr, 1, 1, 1)
                    cairo_show_text(cr, "\(fingers[i])")
                    cairo_new_path(cr)
                }
            } else {
                /// Finger position: draw filled circle
                let y = margin + Double(frets[i]) * fretSpacing - fretSpacing / 2
                cairo_set_source_rgb(cr, 0.551, 0.551, 0.551)
                cairo_arc(cr, x, y, 6, 0, 2 * G_PI)
                cairo_fill(cr)
                if (fingers[i] > 0) {
                    cairo_move_to(cr, x - 2.5, y + 3)
                    cairo_set_source_rgb(cr, 1, 1, 1)
                    cairo_show_text(cr, "\(fingers[i])")
                    cairo_new_path(cr)
                }
            }
        }
    }
    /// Draw notes
    if data.show_notes {
        cairo_set_source_rgb(cr, 0.5, 0.5, 0.5)
        for i in 0..<strings {
            var offset: Double = 0
            if let note = notes[safe: i] {
                offset = note.count == 1 ? 1.1 : 1.25
            }
            let y = (margin / offset) + Double(i) * stringSpacing
            cairo_move_to(cr, y, 110)
            cairo_show_text(cr, notes[safe: i])
        }
    }
}
