//
//  LogUtils.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Utilities for logging
public class LogUtils: @unchecked Sendable {
    /// The shared instance of the logger
    public static let shared = LogUtils()
    /// All the logs
    private var logs: [LogMessage] = []
    /// The queue for setting a log
    private let singletonQueue = DispatchQueue(label: "nl.desbeers.chordprovider.serial.queue")
    /// Private init
    private init() {}

    /// Set a log entry
    /// - Parameters:
    ///   - level: The level of the log
    ///   - category: The category of the log
    ///   - lineNumber: The optional line number
    ///   - message: The message
    public func setLog(level: LogUtils.Level = .notice, category: LogUtils.Category, lineNumber: Int? = nil, message: String) {
        singletonQueue.sync {
            let message = LogUtils.LogMessage(level: level, category: category, lineNumber: lineNumber, message: message)
            logs.append(message)
        }
    }

    /// Fetch the log entries
    /// - Returns: All the log entries
    public func fetchLog() -> [LogUtils.LogMessage] {
        singletonQueue.sync {
            return logs
        }
    }

    /// Clear all the log entries
    public func clearLog() {
        singletonQueue.sync {
            logs = []
        }
    }
}

extension LogUtils {

    /// The structure for a log message
    public struct LogMessage: Equatable, Identifiable, Sendable, Hashable, Codable {
        public init(
            id: UUID = UUID(),
            time: Date = .now,
            level: LogUtils.Level = .notice,
            category: LogUtils.Category,
            lineNumber: Int? = nil,
            message: String = "There are currently no messages"
        ) {
            self.id = id
            self.time = time
            self.level = level
            self.category = category
            self.lineNumber = lineNumber
            self.message = message
        }

        /// The unique ID of the log message
        public var id: UUID = UUID()
        /// The date and time of the log message
        public var time: Date = .now
        /// The level of the log message
        public var level: Level = .notice
        /// The category of the log message
        public var category: Category
        /// The optional line number of the **ChordPro** source
        public var lineNumber: Int?
        /// The log message itself
        public var message: String = "There are currently no messages"
    }
}

extension LogUtils {

    /// The level of the log message
    public enum Level: String, Sendable, Codable {
        /// Debug
        case debug
        /// Info
        case info
        /// Notice
        case notice
        /// Warning
        case warning
        /// Error
        case error
        /// Fault
        case fault
    }
}

extension LogUtils {

    /// The category of the log message
    public enum Category: String, Sendable, Codable {
        /// Song Parser
        case songParser = "Song Parser"
        /// Application
        case application = "Application"
        /// PDF Generator
        case pdfGenerator = "PDF Generator"
        /// File Access
        case fileAccess = "File Access"
        /// JSON Parser
        case jsonParser = "JSON Parser"
    }
}
