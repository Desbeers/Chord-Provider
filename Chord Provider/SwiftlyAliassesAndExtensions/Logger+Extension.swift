//
//  Logger+Extension.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import OSLog

/// Messages for the Logger
public extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""
    static var pdfBuild: Logger {
        Logger(subsystem: subsystem, category: "PDF build")
    }
    static var thumbnailProvider: Logger {
        Logger(subsystem: subsystem, category: "Thumbnail Provider")
    }
    static var application: Logger {
        Logger(subsystem: subsystem, category: "Application")
    }
}
