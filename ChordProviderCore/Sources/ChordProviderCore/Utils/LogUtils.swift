//
//  File.swift
//  ChordProviderCore
//
//  Created by Nick Berendsen on 24/08/2025.
//

import Foundation

#if os(macOS)
/// Utilities to deal with logging
@MainActor @Observable public final class LogUtils {
    /// The shared instance of the class
    public static let shared = LogUtils()
    public var messages: [LogMessage] = []
    public func log( _ message: LogMessage) {
        messages.append(message)
    }
}
#else
    /// Utilities to deal with logging
    @MainActor public final class LogUtils {
    /// The shared instance of the class
    public static let shared = LogUtils()
    public var messages: [LogMessage] = []
    public func log( _ message: LogMessage) {
        messages.append(message)
    }
}
#endif

extension LogUtils {

    /// The structure for a log message
    public struct LogMessage: Equatable, Identifiable, Sendable {
        public init(id: UUID = UUID(), time: Date = .now, type: LogUtils.Level = .notice, category: LogUtils.Category, lineNumber: Int? = nil, message: String = "There are currently no messages") {
            self.id = id
            self.time = time
            self.type = type
            self.category = category
            self.lineNumber = lineNumber
            self.message = message
        }

        /// The unique ID of the log message
        public var id: UUID = UUID()
        /// The date and time of the log message
        public var time: Date = .now
        /// The type of log message
        public var type: Level = .notice
        /// The category of the log message
        public var category: Category
        /// The optional line number of the **ChordPro** source
        public var lineNumber: Int?
        /// The log message itself
        public var message: String = "There are currently no messages"
    }
}

extension LogUtils {

    public enum Level: String, Sendable {
        case debug

        case info

        case notice

        case warning

        case error

        case fault
    }
}

extension LogUtils {

    public enum Category: String, Sendable {
        case songParser = "Song Parser"
        case chordProCliParser = "ChordPro CLI Parser"
        case application = "Application"
        case pdfGenerator = "PDF Generator"
        case fileAccess = "File Access"
    }
}
