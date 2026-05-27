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
        let textBuffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())
        SourceViewController.setupLanguage(textBuffer: textBuffer, language: language)
        gtk_text_buffer_set_text(textBuffer.opaquePointer?.cast(), text, -1)
        let sourceView = ViewStorage(
            gtk_source_view_new_with_buffer(textBuffer.opaquePointer?.cast())?.opaque(),
            content: ["textBuffer": [textBuffer]]
        )
        /// Set the style
        let styleManager = adw_style_manager_get_default()
        SourceViewController.setStyle(sourceView: sourceView, textBuffer: textBuffer, manager: styleManager)
        /// Add a *notification* for style changes
        textBuffer.notify(name: "dark", pointer: styleManager) {
            SourceViewController.setStyle(sourceView: sourceView, textBuffer: textBuffer, manager: styleManager)
        }
        gtk_text_view_set_wrap_mode(sourceView.opaquePointer?.cast(), WrapMode.word.rawValue)
        /// Disable editing
        gtk_text_view_set_editable(sourceView.opaquePointer?.cast(), 0)
        return sourceView
    }
}
