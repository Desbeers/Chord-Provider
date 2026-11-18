//

//  Editor+Controller+marks.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CGtkSourceView

/// The structure of a source mark.
public struct SourceMark {

    /// The line number.
    public var lineNumber: Int
    /// The category.
    public var category: Category

    /// The category options.
    public enum Category: String, CaseIterable {
        /// Info.
        case info
        /// Notice.
        case notice
        /// Warning.
        case warning
        /// Error.
        case error
    }

    /// Init the source mark.
    /// - Parameters:
    ///   - lineNumber: The line number.
    ///   - category: The category.
    public init(lineNumber: Int, category: Category) {
        self.lineNumber = lineNumber
        self.category = category
    }
}

extension SourceMark.Category {

    /// The style of a mark.
    var style: (color: String, icon: String) {
        switch self {
        case .info:
            ("#ffffff", "dialog-information-symbolic")
        case .notice:
            ("#1a5fb4", "view-reveal-symbolic")
        case .warning:
            ("#e5a50a", "dialog-warning-symbolic")
        case .error:
            ("#e01b24", "dialog-error-symbolic")
        }
    }
}

extension Editor.Controller {

    /// Set the style for the markers.
    func setMarksStyle() {
        let darkMode = Self.darkMode
        gtk_source_view_set_show_line_marks(view.sourceEditorPointer, 1)
        for category in SourceMark.Category.allCases {
            let attributes = gtk_source_mark_attributes_new()
            var color = GdkRGBA()
            gtk_source_mark_attributes_set_icon_name(
                attributes,
                category.style.icon
            )
            // The last two hex digits are the alpha channel of the background
            gdk_rgba_parse(&color, "\(category.style.color)\(darkMode ? 20 : 10)")
            gtk_source_mark_attributes_set_background(attributes, &color)
            gtk_source_view_set_mark_attributes(
                view.sourceEditorPointer,
                category.rawValue,
                attributes,
                1
            )
            g_object_unref(UnsafeMutableRawPointer(attributes))
        }
    }

    /// Add a mark to a line in the source editor.
    /// - Parameters:
    ///   - lineNumber: The source line number.
    ///   - category: The category of the mark.
    func addMark(
        lineNumber: Int,
        category: SourceMark.Category
    ) {
        guard lineNumber > 0 else {
            return
        }
        let lineIndex = gint(lineNumber - 1)
        var iter = GtkTextIter()
        gtk_text_buffer_get_iter_at_line(
            buffer.textBufferPointer,
            &iter,
            lineIndex
        )
        gtk_source_buffer_create_source_mark(
            buffer.sourceBufferPointer,
            nil,
            category.rawValue,
            &iter
        )
    }

    /// Clear all marks in the source editor.
    func clearMarks() {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_start_iter(
            buffer.textBufferPointer,
            &start
        )
        gtk_text_buffer_get_end_iter(
            buffer.textBufferPointer,
            &end
        )
        for category in SourceMark.Category.allCases {
            gtk_source_buffer_remove_source_marks(
                buffer.sourceBufferPointer,
                &start,
                &end,
                category.rawValue
            )
        }
    }
}
