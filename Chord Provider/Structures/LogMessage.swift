//
//  ChordPro+LogMessage.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

struct LogMessage: Equatable, Identifiable {
    /// Give it an unique ID
    var id: UUID = UUID()
    /// The date and time of the log item
    var time: Date = .now
    /// The type of log message
    var type: OSLogEntryLog.Level = .notice
    /// The optional line number of the source
    var lineNumber: Int?

    var category: String = "Unknown"
    /// The log message
    var message: String = "There are currently no messages"
}

extension OSLogEntryLog.Level {
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
