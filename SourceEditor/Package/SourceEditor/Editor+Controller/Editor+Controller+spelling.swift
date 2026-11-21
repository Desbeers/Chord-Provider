//
//  Editor+Controller+spelling.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Adwaita
import CLibSpelling

extension Editor.Controller {

    /// Get the state of the spelling checker.
    /// - Parameters:
    ///   - storage: The ``ViewStorage``
    ///   - spelling: Binding to the spelling state.
    static func spelling(storage: ViewStorage, spelling: Binding<Bool>) {
        if let adapter = storage.content["spelling"]?.first {
            // Get a notification when spellcheck has changed.
            adapter.notify(name: "enabled") {
                spelling.wrappedValue = spelling_text_buffer_adapter_get_enabled(adapter.opaquePointer) != 0
            }
            // Get a notification when the language has changed,
            // because then we have to reset the previous spellcheck.
            adapter.notify(name: "language", id: "language", pointer: spelling_checker_get_default()) {
                spelling_text_buffer_adapter_invalidate_all(adapter.opaquePointer)
            }
        }
    }

    /// Set the state of the spelling checker.
    /// - Parameters:
    ///   - storage: The ``ViewStorage``
    ///   - spelling: The spelling state.
    static func spelling(storage: ViewStorage, spelling: Bool) {
        if let adapter = storage.content["spelling"]?.first {
            spelling_text_buffer_adapter_set_enabled(
                adapter.opaquePointer,
                spelling ? 1 : 0
            )
        }
    }
}
