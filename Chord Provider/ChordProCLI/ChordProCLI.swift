//
//  ChordProCLI.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog
import ChordProviderCore

/// Terminal utilities to run the official **ChordPro** CLI to create a PDF
enum ChordProCLI {
    // Just a placeholder
}

extension ChordProCLI {

    /// Run a script in the shell and return its output
    /// - Parameter arguments: The arguments to pass to the shell
    /// - Returns: The output from the shell
    static func runInShell(arguments: [String]) async -> Output {
        /// The normal output
        var allOutput: [OutputItem] = []
        /// The error output
        var allErrors: [OutputItem] = []
        /// Await the results
        for await streamedOutput in runInShell(arguments: arguments) {
            switch streamedOutput {
            case let .standardOutput(output):
                allOutput.append(.init(time: output.time, message: output.message, warning: false))
            case let .standardError(error):
                var warning: Bool = false
                if !error.message.isEmpty {
                    warning = parseChordProMessage(error)
                    allErrors.append(.init(time: error.time, message: error.message, warning: warning))
                }
            }
        }
        /// Return the output
        return Output(
            standardOutput: allOutput,
            standardError: allErrors
        )
    }

    /// Run a script in the shell and return its output
    /// - Parameter arguments: The arguments to pass to the shell
    /// - Returns: The output from the shell as a stream
    static func runInShell(arguments: [String]) -> AsyncStream<StreamedOutput> {
        /// Create the task
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["--login", "-c"] + arguments
        /// Standard output
        let pipe = Pipe()
        task.standardOutput = pipe
        /// Error output
        let errorPipe = Pipe()
        task.standardError = errorPipe
        /// Try to run the task
        do {
            try task.run()
        } catch {
            Logger.chordpro.error("\(error.localizedDescription, privacy: .public)")
        }
        /// Return the stream
        return AsyncStream { continuation in
            pipe.fileHandleForReading.readabilityHandler = { handler in
                guard let standardOutput = String(data: handler.availableData, encoding: .utf8) else {
                    return
                }
                continuation.yield(.standardOutput(.init(time: .now, message: standardOutput, warning: false)))
            }
            errorPipe.fileHandleForReading.readabilityHandler = { handler in
                guard let errorOutput = String(data: handler.availableData, encoding: .utf8) else {
                    return
                }
                continuation.yield(.standardError(.init(time: .now, message: errorOutput, warning: false)))
            }
            /// Finish the stream
            task.terminationHandler = { _ in
                continuation.finish()
            }
        }
    }
}

extension ChordProCLI {

    /// The complete output from the shell
    struct Output {
        /// The standard output
        var standardOutput: [OutputItem]
        /// The standard error
        var standardError: [OutputItem]
    }

    /// The stream output from the shell
    enum StreamedOutput {
        /// The standard output
        case standardOutput(OutputItem)
        /// The standard error
        case standardError(OutputItem)
    }

    /// The structure for an output item
    struct OutputItem {
        /// The time of the output
        let time: Date
        /// The message of the output
        let message: String
        /// Bool if the output is a warning
        let warning: Bool
    }
}

extension ChordProCLI {

    /// We are using the official **ChordPro** binary to create the PDF
    /// - Note: The executable is packed in this application
    static func getChordProBinary() async throws -> URL {
        if
            let which = await ChordProCLI.runInShell(arguments: ["which chordpro"])
                .standardOutput.first?.message.trimmingCharacters(in: .whitespacesAndNewlines),
            which.contains("/chordpro") {
            return URL(filePath: which)
        } else {
            throw AppError.chordProCLINotFound
        }
    }
}

extension ChordProCLI {

    /// Get access to the optional custom config
    static func getOptionalCustomConfig(settings: AppSettings) -> String? {
        if
            settings.chordProCLI.useCustomConfig,
            let persistentURL = UserFileUtils.Selection.customChordProConfig.getBookmarkURL {
            return "--config='\(persistentURL.path)'"
        }
        return nil
    }
}

extension ChordProCLI {

    /// Export a document or folder with the **ChordPro** binary to a PDF
    /// - Parameters:
    ///   - song: The current ``Song``
    ///   - settings: The ``AppSettings``
    /// - Returns: The PDF as `Data` and the status as ``AppError``
    @MainActor static func exportPDF(
        song: Song,
        settings: AppSettings
    ) async throws -> (data: Data, status: AppError) {
        /// Get the **ChordPro** binary
        let chordProApp = try await getChordProBinary()
        /// Remove previous export (if any)
        try? FileManager.default.removeItem(atPath: song.metadata.exportURL.path)
        /// Build the arguments to pass to the shell
        var arguments: [String] = []

        /// Add the optional additional library to the environment of the shell
        if
            settings.chordProCLI.useAdditionalLibrary,
            let persistentURL = UserFileUtils.Selection.customChordProLibrary.getBookmarkURL {
            arguments.append("CHORDPRO_LIB='\(persistentURL.path)'")
        }
        /// The **ChordPro** binary
        arguments.append("\"\(chordProApp.path)\"")
        /// Define the warning messages
        arguments.append("--define diagnostics.format='Line %n, %m'")
        /// Add the source file
        arguments.append("\"\(song.metadata.sourceURL.path)\"")
        /// Add the optional custom config file
        if settings.chordProCLI.useCustomConfig, let customConfig = getOptionalCustomConfig(settings: settings) {
            arguments.append(customConfig)
        }
        /// Add the **Chord Provider** config
        if settings.chordProCLI.useChordProviderSettings {
            let jsonSettings = settings.exportToChordProJSON(chords: song.chords)
            if let config = Bundle.main.url(forResource: "ChordProviderConfig", withExtension: "json") {
                do {
                    var config = try String(contentsOf: config, encoding: .utf8)
                    config = ChordProCLI.applyUserSettings(config: config, settings: settings)
                    try config.write(to: song.metadata.defaultConfigURL, atomically: true, encoding: String.Encoding.utf8)
                    try jsonSettings.write(to: song.metadata.configURL, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    Logger.application.error("\(error.localizedDescription, privacy: .public)")
                }
            }
            arguments.append("--config='\(song.metadata.defaultConfigURL.path)'")
            arguments.append("--config='\(song.metadata.configURL.path)'")
        }
        /// Add the optional local system config that is next to a song file
        if let localSystemConfigURL = song.metadata.localSystemConfigURL {
            arguments.append("--config='\(localSystemConfigURL.path)'")
        }
        /// Add the optional local config that is next to a song file
        if let localSongConfigURL = song.metadata.localSongConfigURL {
            arguments.append("--config='\(localSongConfigURL.path)'")
        }
        /// Add the output file
        arguments.append("--output=\"\(song.metadata.exportURL.path)\"")
        /// Add the process to the log
        Logger.chordpro.info("Creating PDF preview with ChordPro CLI")
        let runChordPro = Task.detached {
            await ChordProCLI.runInShell(arguments: [arguments.joined(separator: " ")])
        }
        let output = await runChordPro.value
        /// Try to get the `Data` from the created PDF
        do {
            let data = try Data(contentsOf: song.metadata.exportURL.absoluteURL)
            /// Return the `Data` and the status of the creation as an ``AppError`
            /// - Note: That does not mean it is has an error, the status is just using the same structure
            return (data, output.standardError.filter { $0.warning == true }.isEmpty ? .noErrorOccurred : .createChordProCLIWarning)
        } catch {
            /// There is no data, throw an ``AppError``
            throw output.standardError.isEmpty ? AppError.emptySong : AppError.createChordProCLIError
        }
    }
}

extension ChordProCLI {

    /// Parse a **ChordPro** message
    /// - Parameters:
    ///   - output: The raw output as read from stdError
    /// - Returns: An item for the internal log
    static func parseChordProMessage(_ output: ChordProCLI.OutputItem) -> Bool {
        /// Cleanup the message
        let message = output.message
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let lineNumberRegex = try? NSRegularExpression(pattern: "^Line (\\d+), (.*)")
        /// Check for a line number
        if
            let match = lineNumberRegex?.firstMatch(in: message, options: [], range: NSRange(location: 0, length: message.utf16.count)),
            let lineNumber = Range(match.range(at: 1), in: message),
            let remaining = Range(match.range(at: 2), in: message) {
            let logMessage = LogMessage(
                time: output.time,
                type: .fault,
                lineNumber: Int(message[lineNumber]),
                message: "Warning: \(String(message[remaining]))"
            )
            Logger.chordpro.fault("**Line \(logMessage.lineNumber ?? 0, privacy: .public)**\n\(String(message[remaining]), privacy: .public)")
            return true
        } else {
            Logger.chordpro.notice("\(message, privacy: .public)")
            return false
        }
    }
}

extension ChordProCLI {

    /// Add the user settings as arguments to **ChordPro** for the Terminal action
    /// - Returns: An array with arguments
    /// - Parameters:
    ///   - config: The **ChordPro** config template
    ///   - settings: The ``AppSettings``
    static func applyUserSettings(config: String, settings: AppSettings) -> String {
        var config = config
        /// Paper size
        let paperSize = settings.pdf.pageSize.rect(settings: settings)
        config = config.replacingOccurrences(of: "pdf.papersize : a4", with: "pdf.papersize : [\(paperSize.width), \(paperSize.height)]")
        /// Optional show only the lyrics
        if settings.application.lyricsOnly {
            config = config.replacingOccurrences(of: "settings.lyrics-only : false", with: "settings.lyrics-only : true")
        }
        if settings.application.repeatWholeChorus {
            config = config.replacingOccurrences(of: "pdf.chorus.recall.quote : false", with: "pdf.chorus.recall.quote : true")
        }
        if settings.diagram.showFingers {
            config = config.replacingOccurrences(of: "pdf.diagrams.fingers : false", with: "pdf.diagrams.fingers : true")
        }
        /// Return the config
        return config
    }
}
