//
//  ChordProEditor+LogItem.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProEditor {

    /// An item for the log
    struct LogItem: Equatable {
        /// Give it an unique ID
        var id: UUID = UUID()
        /// The type of log message
        var type: LogItemType
        /// The optional line number of the source
        var lineNumber: Int?
        /// The log message
        var message: String
    }

    /// The type of log message
    enum LogItemType {
        /// A notice log
        case notice
        /// A warning log
        case warning
        /// An error log
        case error
    }
}
