//
//  Logger+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

/// Messages for the Logger
public extension Logger {

    /// The name of the subsystem
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""

    /// Log PDF build messages
    static var pdfBuild: Logger {
        Logger(subsystem: subsystem, category: "PDF build")
    }
    /// Logthumbnail provider messages
    static var thumbnailProvider: Logger {
        Logger(subsystem: subsystem, category: "Thumbnail Provider")
    }
    /// Log application messages
    static var application: Logger {
        Logger(subsystem: subsystem, category: "Application")
    }
}
