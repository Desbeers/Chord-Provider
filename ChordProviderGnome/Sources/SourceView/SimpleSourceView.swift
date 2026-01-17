//
//  SimpleSourceView.swift
//  GTKSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import ChordProviderCore
import CSourceView

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

    public func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage {
        let buffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())
        SourceViewController.setupLanguage(buffer: buffer, language: language)
        gtk_text_buffer_set_text(buffer.opaquePointer?.cast(), text, -1)
        let storage = ViewStorage(
            gtk_source_view_new_with_buffer(buffer.opaquePointer?.cast())?.opaque(),
            content: ["buffer": [buffer]]
        )
        /// Set the style
        let styleManager = adw_style_manager_get_default()
        SourceViewController.setStyle(buffer: buffer, manager: styleManager)
        /// Add a *notification* for style changes
        buffer.notify(name: "dark", pointer: styleManager) {
            SourceViewController.setStyle(buffer: buffer, manager: styleManager)
        }
        /// Disable editing
        gtk_text_view_set_editable(storage.opaquePointer?.cast(), 0)
        return storage
    }
}
