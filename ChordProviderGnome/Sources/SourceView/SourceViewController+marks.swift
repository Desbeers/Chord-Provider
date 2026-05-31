//
//  SourceViewController+marks.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CSourceView
import ChordProviderCore

extension SourceViewController {

    /// Set the style for the markers
    /// - Parameters:
    ///   - view: The GTKSourceView widget
    ///   - darkMode: Bool if the `View` is in dark mode
    ///
    /// - Note: This function is `static` because it will be called from a 'GTK Signal'
    static func setMarksStyle(view: ViewStorage, darkMode: Bool) {
        for level in LogUtils.Level.allCases {
            gtk_source_view_set_show_line_marks(view.sourceViewPointer, 1)
            let attributes = gtk_source_mark_attributes_new()
            var color = GdkRGBA()
            gtk_source_mark_attributes_set_icon_name(
                attributes,
                level.style.icon
            )
            gdk_rgba_parse(&color, "\(level.style.color)\(darkMode ? 20 : 10)")
            gtk_source_mark_attributes_set_background(attributes, &color)
            gtk_source_view_set_mark_attributes(view.sourceViewPointer, level.rawValue, attributes, 1)
        }
    }

    /// Add  mark to a line in the source editor
    /// - Parameters:
    ///   - lineNumber: The source line number
    ///   - category: The category of the mark
    ///
    func addMark(
        lineNumber: Int,
        category: String
    ) {
        guard lineNumber > 0 else {
            return
        }
        let lineIndex = gint(lineNumber - 1)
        var iter = GtkTextIter()
        gtk_text_buffer_get_iter_at_line(
            textBuffer,
            &iter,
            lineIndex
        )
        gtk_source_buffer_create_source_mark(
            sourceBuffer,
            nil,
            category,
            &iter
        )
    }

    /// Clear all marks in the source editor
    /// - Parameter buffer:The buffer with the text 
    func clearMarks() {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_start_iter(
            textBuffer,
            &start
        )
        gtk_text_buffer_get_end_iter(
            textBuffer,
            &end
        )
        for category in LogUtils.Level.allCases {
            gtk_source_buffer_remove_source_marks(
                sourceBuffer,
                &start,
                &end,
                category.rawValue
            )
        }
    }
}
