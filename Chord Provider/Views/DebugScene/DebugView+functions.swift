//
//  DebugView+functions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog
import ChordProviderCore

extension DebugView {

    func getSource() async {
        if let song = appState.song {
            var source: [(line: Int, source: Song.Section.Line)] = []
            for line in song.sections.flatMap(\.lines) {
                source.append((line: line.sourceLineNumber, source: line))
            }
            self.source = source
        } else {
            self.source = []
        }
    }

    func getLog() async {

        let osLog = Task.detached {
            do {
                /// Give the GUI some time to render
                try await Task.sleep(for: .seconds(1))
                let store = try OSLogStore(scope: .currentProcessIdentifier)
                let position = store.position(timeIntervalSinceLatestBoot: 1)
                return try store
                    .getEntries(at: position)
                    .compactMap { $0 as? OSLogEntryLog }
                    .filter { $0.subsystem == Bundle.main.bundleIdentifier ?? "" }
                    .map { line in
                        LogMessage(
                            time: line.date,
                            type: line.level,
                            category: line.category,
                            message: line.composedMessage
                        )
                    }
            } catch {
                Logger.application.warning("\(error.localizedDescription, privacy: .public)")
                return [LogMessage()]
            }
        }
        do {
            try Task.checkCancellation()
            /// Only get new messages, I can't get just recent logs based on time on macOS
            let newMessages = await osLog.value.filter { $0.time > lastFetchedLogDate }.map { line in
                parseLine(line)
            }
            try Task.checkCancellation()
            osLogMessages.append(contentsOf: newMessages)
            lastFetchedLogDate = .now
        } catch {
            /// Fetching log is canceled
        }
    }

    /// Parse a line in the log
    /// - Parameter line: The line to parse
    /// - Returns: The parsed line
    private func parseLine(_ line: LogMessage) -> LogMessage {
        var line = line
        let lineRegex = /(\*\*Line )(.+?)(\*\*\n)/
        if let result = try? lineRegex.firstMatch(in: line.message) {
            line.message = String(line.message.dropFirst(result.0.count))
            line.lineNumber = Int(result.2)
        }
        return line
    }
}
