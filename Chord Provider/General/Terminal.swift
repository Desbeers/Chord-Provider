//
//  Terminal.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers
import OSLog

/// Terminal utilities
enum Terminal {
    // Just a placeholder
}

extension Terminal {

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

extension Terminal {

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

extension Terminal {

    /// We are using the official **ChordPro** binary to create the PDF
    /// - Note: The executable is packed in this application
    static func getChordProBinary() async throws -> URL {
        if
            let which = await Terminal.runInShell(arguments: ["which chordpro"])
                .standardOutput.first?.message.trimmingCharacters(in: .whitespacesAndNewlines),
            which.contains("/chordpro") {
            return URL(filePath: which)
        } else {
            throw AppError.binaryNotFound
        }
    }
}

extension Terminal {

    /// Get access to the optional custom config
    static func getOptionalCustomConfig(settings: AppSettings) -> String? {
        if
            settings.chordPro.useCustomConfig,
            let persistentURL = UserFile.customChordProConfig.getBookmarkURL {
            return "--config='\(persistentURL.path)'"
        }
        return nil
    }
}

extension Terminal {

    /// Export a document or folder with the **ChordPro** binary to a PDF
    /// - Parameters:
    ///   - sceneState: The current scene state
    /// - Returns: The PDF as `Data` and the status as ``AppError``
    @MainActor static func exportPDF(
        sceneState: SceneStateModel
    ) async throws -> (data: Data, status: AppError) {
        /// Shortcut
        let song = sceneState.song
        /// Get the **ChordPro** binary
        let chordProApp = try await getChordProBinary()
        /// Remove previous export (if any)
        try? FileManager.default.removeItem(atPath: sceneState.exportURL.path)
        /// Write the song and settings to the source URL
        /// - Note: We don't read the file URL directly because it might not be saved yet
        do {
            try song.content.write(to: sceneState.sourceURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            throw AppError.writeDocumentError
        }
        /// Build the arguments to pass to the shell
        var arguments: [String] = []

        /// Add the optional additional library to the environment of the shell
        if
            song.settings.chordPro.useAdditionalLibrary,
            let persistentURL = UserFile.customChordProLibrary.getBookmarkURL {
            arguments.append("CHORDPRO_LIB='\(persistentURL.path)'")
        }
        /// The **ChordPro** binary
        arguments.append("\"\(chordProApp.path)\"")
        /// Define the warning messages
        arguments.append("--define diagnostics.format='Line %n, %m'")
        /// Add the source file
        arguments.append("\"\(sceneState.sourceURL.path)\"")
        /// Add the optional custom config file
        if song.settings.chordPro.useCustomConfig, let customConfig = getOptionalCustomConfig(settings: song.settings) {
            arguments.append(customConfig)
        }

        dump(song.settings.chordPro.useChordProviderSettings)

        /// Add the **Chord Provider** config
        if song.settings.chordPro.useChordProviderSettings {
            let jsonSettings = song.settings.exportToChordProJSON(chords: song.chords)
            if let config = Bundle.main.url(forResource: "ChordProviderConfig", withExtension: "json") {
                do {
                    var config = try String(contentsOf: config, encoding: .utf8)
                    config = AppStateModel.applyUserSettings(config: config, settings: song.settings)
                    try config.write(to: sceneState.defaultConfigURL, atomically: true, encoding: String.Encoding.utf8)
                    try jsonSettings.write(to: sceneState.configURL, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    Logger.application.error("\(error.localizedDescription, privacy: .public)")
                }
            }
            arguments.append("--config='\(sceneState.defaultConfigURL.path)'")
            arguments.append("--config='\(sceneState.configURL.path)'")
        }
        /// Add the optional local system config that is next to a song file
        if let localSystemConfigURL = sceneState.localSystemConfigURL {
            arguments.append("--config='\(localSystemConfigURL.path)'")
        }
        /// Add the optional local config that is next to a song file
        if let localSongConfigURL = sceneState.localSongConfigURL {
            arguments.append("--config='\(localSongConfigURL.path)'")
        }
        /// Add the output file
        arguments.append("--output=\"\(sceneState.exportURL.path)\"")
        /// Add the process to the log
        Logger.chordpro.info("Creating PDF preview with ChordPro CLI")
        let runChordPro = Task.detached {
            await Terminal.runInShell(arguments: [arguments.joined(separator: " ")])
        }
        let output = await runChordPro.value
        /// Try to get the `Data` from the created PDF
        do {
            let data = try Data(contentsOf: sceneState.exportURL.absoluteURL)
            /// Return the `Data` and the status of the creation as an ``AppError`
            /// - Note: That does not mean it is has an error, the status is just using the same structure
            return (data, output.standardError.filter { $0.warning == true }.isEmpty ? .noErrorOccurred : .createChordProPdfWarning)
        } catch {
            /// There is no data, throw an ``AppError``
            throw output.standardError.isEmpty ? AppError.emptySong : AppError.createChordProPdfError
        }
    }
}

extension Terminal {

    /// Parse a **ChordPro** message
    /// - Parameters:
    ///   - output: The raw output as read from stdError
    /// - Returns: An item for the internal log
    static func parseChordProMessage(_ output: Terminal.OutputItem) -> Bool {
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
