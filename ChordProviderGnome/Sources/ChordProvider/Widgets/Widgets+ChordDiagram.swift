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

    /// The `View` for all the chord variations
    struct ChordDiagram: View {
        /// The chord definition
        let chord: ChordDefinition
        /// The width of the diagram
        var width: Double = 100
        /// The settings of the application
        let settings: ChordProviderSettings
        /// The body of the `View`
        var  view: Body {
            Diagram(chord: chord, width: width, settings: settings)
                .frame(minWidth: Int(width), minHeight: Int(width * 1.2))
                .frame(maxWidth: Int(width))
                .frame(maxHeight: Int(width * 1.2))
                .valign(.center)
                .halign(.center)
        }
    }

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
            let context = Context(strings: settings.instrument.strings.count)
            convert(context: context)
            let drawingArea = gtk_drawing_area_new()
            gtk_drawing_area_set_content_width(drawingArea?.cast(), Int32(width))
            gtk_drawing_area_set_content_height(drawingArea?.cast(), Int32(width * 1.2))
            gtk_drawing_area_set_draw_func(drawingArea?.cast(), draw_chord, Unmanaged.passRetained(context).toOpaque()) { userData in
                Unmanaged<Context>.fromOpaque(userData!).release()
            }
            let storage = ViewStorage(drawingArea?.opaque())
            storage.fields["settings"] = settings
            storage.fields["chord"] = chord
            storage.fields["context"] = context
            update(storage, data: data, updateProperties: true, type: type)
            return storage
        }

        func update<Data>(
            _ storage: ViewStorage,
            data: WidgetData,
            updateProperties: Bool,
            type: Data.Type
        ) where Data: ViewRenderData {
            if updateProperties, let settingsStorage = storage.fields["settings"] as? ChordProviderSettings, let chordStorage = storage.fields["chord"] as? ChordDefinition, let context = storage.fields["context"] as? Context {
                if settings.diagram != settingsStorage.diagram || chord != chordStorage {
                    convert(context: context)
                    storage.fields["settings"] = settings
                    storage.fields["chord"] = chord
                    storage.fields["context"] = context
                    Idle {
                        gtk_widget_queue_draw(storage.opaquePointer?.cast())
                    }
                }
                storage.previousState = self
            }
        }

        func convert(context: Context) {
            context.showNotes = settings.diagram.showNotes
            context.baseFret = chord.baseFret
            for index in 0..<6 {
                context.setFret(chord.frets[safe: index] ?? 0, on: index)
                context.setFinger(chord.fingers[safe: index] ?? 0, on: index)
            }
            let fallback = Chord.Barre(finger: -1, fret: 0, startIndex: 0, endIndex: 0)
            for index in 0..<5 {
                context.setBarre(at: index, barre: chord.barres?[safe: index] ?? fallback)
            }
            for (index, note) in chord.components.enumerated() {
                context.setNote(note.note == .none ? " " : note.note.display, on: index)
            }
        }
    }
}

/// Draw a chord diagram with *Cairo*
///
/// - Note: Declare C function implementations as `public` to ensure they're not optimized away.
@_cdecl("draw_chord_swift")
public func drawChord(
    cr: OpaquePointer,
    width: Int32,
    height: Int32,
    user_data: gpointer,
    dark_mode: gboolean
) {

    var drawnBarres = Set<Int>()

    let data = Unmanaged<Widgets.Diagram.Context>
        .fromOpaque(user_data)
        .takeUnretainedValue()
    let color: Double = dark_mode == 0 ? 0 : 1
    let strings = data.strings
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
    if data.baseFret == 1 {
        cairo_set_source_rgb(cr, color, color, color)
        cairo_set_line_width(cr, fontSize / 4)
        cairo_move_to(cr, margin - 1, margin)
        cairo_line_to(cr, width - margin + 1, margin)
        cairo_stroke(cr)
        cairo_set_line_width(cr, 0.2)
    } else {
        let xOffset = margin * (data.baseFret > 9 ? 0.2 : 0.4)
        cairo_set_source_rgb(cr, 0.5, 0.5, 0.5)
        cairo_move_to(cr, xOffset, margin + fretSpacing / 1.5)
        cairo_show_text(cr, "\(data.baseFret)")
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

        let fret = data[fret: index]
        let finger = data[finger: index]
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
            if let barre = data.barre(atFret: fret), !drawnBarres.contains(barre.fret) {
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
                var offset: Double = 0
                if let note = data.note(on: index) {
                    offset = note.count == 1 ? 1.1 : 1.25
                }
                let y = (margin / offset) + Double(index) * stringSpacing
                cairo_move_to(cr, y, height - fontSize * 1.4)
                cairo_show_text(cr, data.note(on: index))
            }
        }
}
