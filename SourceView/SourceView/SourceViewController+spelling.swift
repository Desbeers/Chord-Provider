//
//  SourceViewController+language.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CGtkSourceView
import CLibSpelling

extension SourceViewController {

    /// Setup spelling.
    func setupSpelling() {
        guard
            let checker = spelling_checker_get_default(),
            let textView = view.textViewPointer,
            let widget = view.widgetPointer,
            let buffer = gtk_text_view_get_buffer(textView),
            let adapter = spelling_text_buffer_adapter_new(
                UnsafeMutableRawPointer(buffer).assumingMemoryBound(to: GtkSourceBuffer.self),
                checker
            )
        else { return }
        gtk_text_view_set_extra_menu(textView, spelling_text_buffer_adapter_get_menu_model(adapter))
        gtk_widget_insert_action_group(widget, "spelling", adapter)
        spelling_text_buffer_adapter_set_enabled(adapter, spelling.wrappedValue ? 1 : 0)
        view.fields["spelling"] = adapter
        // Get a notification when the language has changed,
        // because then we have to reset the previous spellcheck.
        view.notify(name: "language", id: "language", pointer: checker) {
            spelling_text_buffer_adapter_invalidate_all(adapter)
        }
        // Get a notification when spellcheck has changed.
        view.notify(name: "enabled", id: "enabled", pointer: adapter) {
            self.spelling.wrappedValue = spelling_text_buffer_adapter_get_enabled(adapter) != 0
        }
    }
}
