// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser
import ChordProviderCore
import ChordProviderHTML

@main
struct Chordprovider: AsyncParsableCommand {
    /// The **ChordPro** source
    @Argument(
        help:
            ArgumentHelp(
                "The ChordPro song to parse.",
                discussion: "This can be a file path or a string containing the ChordPro source.",
                valueName: "source"
            )
    )
    public var source: String
    /// The output format
    @Option(help: "The output format.")
    public var format: OutputFormat = .html
    /// The instrument
    @Option(name: [.long, .customShort("i")], help: "The instrument to use.")
    public var instrument: Chord.Instrument = .guitar
    /// Clean source option
    @Flag(
        name: [.long, .customShort("c")],
        help:
            ArgumentHelp(
                "Try to clean the source.",
                discussion: "This is only useful when the output is set to 'source.",
            )
    )
    var cleanSource: Bool = false
    /// Option for only lyrics
    @Flag(name: [.long, .customShort("l")], help: "Only prints lyrics")
    var lyricsOnly: Bool = false
    /// Option for repeating the whole  chorus
    @Flag(name: [.long, .customShort("r")], help: "Repeat whole chorus")
    var repeatWholeChorus: Bool = false
    /// Option to print the result to `stdout`
    @Flag(name: [.long, .customShort("s")], help: "Prints the result to stdout")
    var stdout: Bool = false
    /// The optional output URL
    @Option(
        name: [.long, .customShort("o")],
        help:
            ArgumentHelp(
                "The output file.",
                discussion: outputDiscussion,
                valueName: "file")
    )
    public var output: String?

    /// The configuration
    static let configuration = CommandConfiguration(
        commandName: "chordprovider", // defaults to the type name, hyphen-separated and lowercase
        abstract: "Convert a ChordPro song into another format",
        discussion: configurationDiscussion,
    )

    /// The main function
    mutating func run() async throws {
        /// Set the settings
        let settings = ChordProviderSettings(
            instrument: instrument,
            lyricOnly: lyricsOnly,
            repeatWholeChorus: repeatWholeChorus
        )
        /// The default song
        var parsedSong = Song(id: UUID())
        /// The default result
        var result: String = "Error parsing the song"

        /// Set the source URL
        let url = URL(filePath: source)
        do {
            try checkURL(url)
            /// The URL is valid and its content will be used
            parsedSong = try SongFileUtils.parseSongFile(fileURL: url, instrument: instrument, prefixes: [], getOnlyMetadata: false)
        } catch {
            /// The URL is not valid so the direct source will be used
            parsedSong.content = source
            parsedSong = ChordProParser.parse(song: parsedSong, instrument: instrument, prefixes: [])
            /// Write to stdout if no output URL is given
            if output == nil {
                stdout = true
            }
        }

        /// Clean the source if requested
        if format == .source && cleanSource {
            result = parsedSong.sections.flatMap(\.lines).map(\.sourceParsed).joined(separator: "\n")
            /// Parse again to reset the warnings
            LogUtils.shared.clearLog()
            parsedSong.content = result
            parsedSong = ChordProParser.parse(song: parsedSong, instrument: instrument, prefixes: [])
        }

        /// Set the destination URL
        var destination = URL(filePath: source)
        if let output {
            destination = URL(fileURLWithPath: output)
        } else {
            destination = destination.deletingPathExtension().appendingPathExtension(format.rawValue)
        }

        /// Get the result
        switch format {
        case .json:
            if let json = try? JSONUtils.encode(parsedSong) {
                result = json
            }
        case .source:
            result = parsedSong.content
        case .html:
            result = HtmlRender.render(song: parsedSong, settings: settings)
        }

        /// Output the result
        if stdout {
            print(result)
        } else {
            do {
                let fileManager = FileManager.default
                /// Remove previous export (if any)
                try? fileManager.removeItem(atPath: destination.path)
                try result.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
                print(messages().joined(separator: "\n"))
                print("Converted \(url.lastPathComponent) to \(destination.lastPathComponent)")
            } catch {
                print("Error writing to file: \(destination.path())")
            }
        }
    }

    func checkURL(_ url: URL) throws {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw ValidationError("File not found: \(url)")
        }
    }

    func messages() -> [String] {
        LogUtils.shared.fetchLog()
            .map { message in
                var line = message.type.rawValue + ": " + message.category.rawValue + ": "
                if let lineNumber = message.lineNumber {
                    line += "line \(lineNumber): "
                }

                return line + message.message
            }
    }
}
