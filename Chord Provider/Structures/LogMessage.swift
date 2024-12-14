//
//  ChordPro+LogMessage.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

enum LogMessage {
    // Just a placeholder
}

extension LogMessage {

    /// An item for the log
    struct Item: Equatable, Identifiable {
        /// Give it an unique ID
        var id: UUID = UUID()
        /// The date and time of the log item
        var time: Date = .now
        /// The type of log message
        var type: ItemType = .notice
        /// The optional line number of the source
        var lineNumber: Int?
        /// The log message
        var message: String = "There are currently no messages"
    }

    /// The type of log message
    enum ItemType {
        /// A notice log
        case notice
        /// A warning log
        case warning
        /// An error log
        case error
        /// The color for an log message
        var color: Color {
            switch self {
            case .notice:
                return Color.blue
            case .warning:
                return Color.orange
            case .error:
                return Color.red
            }
        }
    }
}
