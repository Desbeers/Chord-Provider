//
//  SimpleSourceView.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CGtkSourceView

/// A simple code widget for highlighting text only
public struct SimpleSourceView: AdwaitaWidget {

    /// The text
    var text: String
    /// The ``Language``
    var language: Language
    /// Init the widget
    public init(
        text: String,
        language: Language
    ) {
        self.text = text
        self.language = language
    }

    /// The view storage.
    /// - Parameters:
    ///   - data: The widget data.
    ///   - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage {
        let buffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())
        gtk_text_buffer_set_text(buffer.textBufferPointer, text, -1)
        let view = ViewStorage(
            gtk_source_view_new_with_buffer(buffer.sourceBufferPointer)?.opaque(),
            content: ["buffer": [buffer]]
        )
        // Set the style
        setStyle(buffer: buffer)
        SourceViewController.initLanguage(buffer: buffer, language: language, snippets: nil)
        // Wrap by word
        gtk_text_view_set_wrap_mode(view.textViewPointer, WrapMode.word.gtkValue)
        // Disable editing
        gtk_text_view_set_editable(view.textViewPointer, 0)
        // Add a *notification* for style changes
        view.notify(name: "dark", pointer: adw_style_manager_get_default()) {
            setStyle(buffer: buffer)
        }
        return view
    }

    /// Set the style of the editor.
    /// - Parameter buffer: The text buffer.
    private func setStyle(buffer: ViewStorage) {
        let scheme = SourceViewController.darkMode ? "Adwaita-dark" : "Adwaita"
        let gtkStyleManager = gtk_source_style_scheme_manager_get_default()
        let schemePointer = gtk_source_style_scheme_manager_get_scheme(gtkStyleManager, scheme)
        gtk_source_buffer_set_style_scheme(buffer.sourceBufferPointer, schemePointer)
    }
}
