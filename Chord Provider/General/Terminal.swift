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
            print(error.localizedDescription)
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
        let time: Date
        let message: String
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
            /// Get access to the URL
            _ = persistentURL.startAccessingSecurityScopedResource()
            /// Close the access
            UserFile.customChordProConfig.stopCustomFileAccess()
            return "--config='\(persistentURL.path)'"
        }
        return nil
    }
}

extension Terminal {

    /// Export a document or folder with the **ChordPro** binary to a PDF
    /// - Parameters:
    ///   - text: The current text of the document
    ///   - settings: The current ``AppSettings``
    ///   - sceneState: The current ``SceneStateModel``
    ///   - fileList: The optional list of files (for a songbook)
    ///   - title: The title of the export
    ///   - subtitle: The optional subtitle of the export
    /// - Returns: The PDF as `Data` and the status as ``AppError``
    @MainActor static func exportPDF(
        text: String,
        settings: AppSettings,
        sceneState: SceneStateModel,
        fileList: Bool = false,
        title: String = "",
        subtitle: String = ""
    ) async throws -> (data: Data, status: AppError) {
        /// Get the **ChordPro** binary
        let chordProApp = try await getChordProBinary()
        /// Remove previous export (if any)
        try? FileManager.default.removeItem(atPath: sceneState.exportURL.path)
        /// Write the song to the source URL
        /// - Note: We don't read the file URL directly because it might not be saved yet
        do {
            try text.write(to: sceneState.sourceURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            throw AppError.writeDocumentError
        }
        /// Build the arguments to pass to the shell
        var arguments: [String] = []

        /// Add the optional additional library to the environment of the shell
        if
            settings.chordPro.useAdditionalLibrary,
            let persistentURL = UserFile.customChordProLibrary.getBookmarkURL {
            /// Get access to the URL
            _ = persistentURL.startAccessingSecurityScopedResource()
            arguments.append("CHORDPRO_LIB='\(persistentURL.path)'")
            /// Close the access
            UserFile.customChordProConfig.stopCustomFileAccess()
        }
        /// The **ChordPro** binary
        arguments.append("\"\(chordProApp.path)\"")
        /// Define the warning messages
        arguments.append("--define diagnostics.format='Line %n, %m'")
        /// Add the source file
        arguments.append("\"\(sceneState.sourceURL.path)\"")
        /// Get the user settings that are simple and do not need sandbox help
        arguments.append(contentsOf: AppStateModel.getUserSettings(settings: settings))
        /// Add the optional custom config file
        if settings.chordPro.useCustomConfig, let customConfig = getOptionalCustomConfig(settings: settings) {
            arguments.append(customConfig)
        }
        /// Add the optional local system config that is next to a song file
        if let localSystemConfigURL = sceneState.localSystemConfigURL {
            _ = localSystemConfigURL.startAccessingSecurityScopedResource()
            arguments.append("--config='\(localSystemConfigURL.path)'")
            UserFile.customChordProConfig.stopCustomFileAccess()
        }
        /// Add the optional local config that is next to a song file
        if let localSongConfigURL = sceneState.localSongConfigURL {
            _ = localSongConfigURL.startAccessingSecurityScopedResource()
            arguments.append("--config='\(localSongConfigURL.path)'")
            UserFile.customChordProConfig.stopCustomFileAccess()
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
