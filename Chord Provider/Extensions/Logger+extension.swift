//
//  Logger+extension.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

/// Messages for the Logger
extension Logger {

    /// The name of the subsystem
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""
    /// Log PDF build messages
    static var pdfBuild: Logger {
        Logger(subsystem: subsystem, category: "PDF build")
    }
    /// Log application messages
    static var application: Logger {
        Logger(subsystem: subsystem, category: "Application")
    }
    /// Log parser messages
    static var parser: Logger {
        Logger(subsystem: subsystem, category: "Song Parser")
    }
    /// Song view build messages
    static var viewBuild: Logger {
        Logger(subsystem: subsystem, category: "View Build")
    }
    /// ChordPro CLI messages
    static var chordpro: Logger {
        Logger(subsystem: subsystem, category: "ChordPro")
    }
    /// Log file access messages
    static var fileAccess: Logger {
        Logger(subsystem: subsystem, category: "File Access")
    }
}
