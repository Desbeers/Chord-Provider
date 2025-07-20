//
//  DebugView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` for the debug window
struct DebugView: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// The currently selected tab
    @State private var tab: Message = .log
    /// The source of the song
    @State var content: [(line: Int, source: Song.Section.Line)] = []
    /// The currently selected line
    @State var selectedLine: Int?
    /// All parsed log messages
    @State var osLogMessages: [LogMessage] = []
    /// JSON part
    @State var jsonPart: Part = .metadata
    /// Remember the last fetched time
    @State private var lastFetchedLogDate = Calendar.current.date(byAdding: .year, value: -1000, to: Date()) ?? Date()
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            switch tab {
            case .log:
                log
            case .json:
                json
            case .source:
                source
            }
        }
        .frame(minWidth: 500, minHeight: 600)
        .frame(maxWidth: .infinity)
        .background(Color(NSColor.textBackgroundColor))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Tab", selection: $tab) {
                    ForEach(Message.allCases, id: \.self) { tab in
                        Label(tab.rawValue, systemImage: "gear")
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .labelStyle(.titleAndIcon)
        .animation(.default, value: appState.song)
        .animation(.default, value: tab)
        .task(id: appState.song) {
            if let song = appState.song {
                var content: [(line: Int, source: Song.Section.Line)] = []
                for line in song.sections.flatMap(\.lines) {
                    content.append((line: line.sourceLineNumber, source: line))
                }
                self.content = content
            } else {
                self.content = []
            }
        }
        .task(id: appState.lastUpdate) {
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
            /// Only get new messages, I can't get just recent logs based on time on macOS
            let newMessages = await osLog.value.filter { $0.time > lastFetchedLogDate }.map { line in
                parseLine(line)
            }

            osLogMessages.append(contentsOf: newMessages)
            lastFetchedLogDate = .now
        }
        .task(id: tab) {
            selectedLine = nil
        }
    }

    /// No song View
    var noSong: some View {
        ContentUnavailableView("No song open", systemImage: "music.quarternote.3")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
