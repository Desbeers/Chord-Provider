//
//  ChordPro+LogMessage.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// The structure for a log message
struct LogMessage: Equatable, Identifiable {
    /// Give it an unique ID
    var id: UUID = UUID()
    /// The date and time of the log item
    var time: Date = .now
    /// The type of log message
    var type: OSLogEntryLog.Level = .notice
    /// The optional line number of the source
    var lineNumber: Int?
    /// The category of the log
    var category: String = "Unknown"
    /// The log message
    var message: String = "There are currently no messages"
}

extension OSLogEntryLog.Level {
    /// The SwiftUI `Color` for the level of the log
    var color: Color {
        switch self {
        case .undefined:
            Color.primary
        case .debug:
            Color.indigo
        case .info:
            Color.mint
        case .notice:
            Color.blue
        case .error:
            Color.red
        case .fault:
            Color.orange
        @unknown default:
            Color.primary
        }
    }
}
