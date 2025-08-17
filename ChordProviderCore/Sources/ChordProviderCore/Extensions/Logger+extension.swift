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
    /// Log parser messages
    public static var parser: Logger {
        Logger(subsystem: subsystem, category: "Song Parser")
    }
    public static var json: Logger {
        Logger(subsystem: subsystem, category: "JSON")
    }
}
