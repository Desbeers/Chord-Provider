//
//  DebugMessage.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The debug messages in the ``DebugView``
enum DebugMessage: String, CaseIterable {
    /// Log messages
    case log = "Log output"
    /// Song source messages
    case source = "Generated Source"
    /// Generated JSON mesages
    case json = "JSON output"
}
