//
//  DebugView+Message.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension DebugView {

    /// The debug messages in the ``DebugView``
    enum Message: String, CaseIterable {
        /// Log messages
        case log = "Log output"
        /// Song source messages
        case source = "Generated Source"
        /// Generated JSON messages
        case json = "JSON output"
        /// Commodore 64
        case commodore64 = "Commodore 64"
    }
}
