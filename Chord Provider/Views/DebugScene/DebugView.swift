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
    @Environment(AppStateModel.self) private var appState
    /// The currently selected tab
    @State private var tab: Message = .log
    /// The source of the song
    @State private var content: [(line: Int, source: Song.Section.Line)] = []
    /// The currently selected line
    @State private var selectedLine: Int?
    /// All parsed log messages
    @State private var osLogMessages: [LogMessage] = []
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
        .background(Color(NSColor.windowBackgroundColor))
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
        .task(id: appState.song) {
            if let song = appState.song {
                var content: [(line: Int, source: Song.Section.Line)] = []
                for line in song.sections.flatMap(\.lines) {
                    content.append((line: line.sourceLineNumber, source: line))
                }
                self.content = content
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
    /// The source tab of the `View`
    @ViewBuilder var source: some View {
        List(selection: $selectedLine) {
            ForEach(content, id: \.line) { line in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(line.line)")
                            .frame(width: 30, alignment: .trailing)
                            .font(
                                .body
                                    .weight(line.source.warnings == nil ? .regular : .bold)
                            )
                        VStack(alignment: .leading) {
                            Text(line.source.source)
                            if let warnings = line.source.warnings {
                                Text(.init("\(warnings.joined(separator: ", "))"))
                                    .foregroundStyle(.red)
                                    .font(.caption)
                            }
                            if line.source.sourceLineNumber < 1 {
                                Text("The directive is added by the parser")
                                    .foregroundStyle(.green)
                                    .font(.caption)
                            }
                            Text("Environment: **\(line.source.directive.details.environment.rawValue)**")
                                .foregroundStyle(.gray)
                        }
                    }
                    .tag(line.line)
                    if line.line == selectedLine {
                        Text(ChordProParser.encode(line.source))
                            .padding(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(nsColor: .textBackgroundColor))
                            .foregroundStyle(Color(nsColor: .textColor))
                            .padding(.horizontal, 30)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        VStack(alignment: .leading) {
            Label("A negative line number means the line is added by the *parser* and is not part of the current document", systemImage: "info.circle")
            Label("A **bold** line number means the *source line* has warnings that the parser will try to resolve", systemImage: "exclamationmark.triangle")
        }
        .font(.caption)
        .padding()
        .foregroundStyle(.secondary)
    }
    /// The json tab of the `View`
    var json: some View {
        ScrollView {
            Form {
                LazyVStack {
                    if let song = appState.song {
                        let metadata = ChordProParser.encode(song.metadata)
                        jsonPart(label: "Meta Data", content: metadata)

                        ForEach(song.sections) { section in
                            Divider()
                            let content = ChordProParser.encode(section)
                            jsonPart(label: "Section \(section.environment.rawValue)", content: content)
                        }
                        let chords = ChordProParser.encode(song.chords)
                        jsonPart(label: "Chords", content: chords)
                    } else {
                        Text("No song open")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .labeledContentStyle(.debug)
    }
    func jsonPart(label: String, content: String) -> some View {
        Section {
            LabeledContent {
                Text(content)
            } label: {
                Text(label)
            }
        }
        .padding()
    }
    /// The log tab of the `View`
    var log: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    LazyVStack(spacing: 0) {
                        /// - Note: This *must* be a LazyVStack or else memory usage will go nuts
                        ForEach(osLogMessages) { log in
                            VStack(alignment: .leading, spacing: 0) {
                                Divider()
                                HStack(alignment: .top, spacing: 0) {
                                    Image(systemName: "exclamationmark.bubble")
                                        .foregroundStyle(log.type.color)
                                        .padding(.trailing, 4)
                                    Text(log.time.formatted(date: .omitted, time: .standard))
                                    Text(": ")
                                    Text(log.category)
                                    Text(": ")
                                    if let lineNumber = log.lineNumber {
                                        Text("**Line \(lineNumber)**: ")
                                    }
                                    Text(.init(log.message))
                                }
                                .padding(8)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(log.type.color.opacity(0.2))
                        }
                        /// Just use this as anchor point to keep the scrollview at the bottom
                        Divider()
                            .id(1)
                            .task {
                                value.scrollTo(1)
                            }
                            .onChange(of: osLogMessages) {
                                value.scrollTo(1)
                            }
                    }
                }
            }
            Button("Clear Log Messages") {
                osLogMessages = []
            }
            .padding(.bottom)
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
