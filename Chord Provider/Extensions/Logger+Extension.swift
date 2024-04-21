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
    static let pdfBuild = Logger(subsystem: subsystem, category: "PDF build")
    static let thumbnailProvider = Logger(subsystem: subsystem, category: "Thumbnail Provider")
}
