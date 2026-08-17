//
//  SimpleSourceView.swift
//  ChordProviderEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import ChordProviderCore
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
        SourceViewController.initStyle(
            view: view,
            buffer: buffer,
            language: language
        )
        // Wrap by word
        gtk_text_view_set_wrap_mode(view.textViewPointer, WrapMode.word.rawValue)
        // Disable editing
        gtk_text_view_set_editable(view.textViewPointer, 0)
        return view
    }
}
