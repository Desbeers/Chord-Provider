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
    @Argument(help: "The ChordPro song to parse.")
    public var source: String
    @Option(help: "The output format.")
    public var format: OutputFormat = .html
    @Option(name: [.long, .customShort("o")], help: ArgumentHelp(
        "The output file.",
        discussion: "If no output file is provided, the output will be next to the song.",
        valueName: "file"))
    public var output: String?
    @Flag(name: [.customLong("lyrics-only"), .customShort("l")], help: "Only prints lyrics")
    var lyricsOnly: Bool = false
    @Flag(help: "Prints to stdout")
    var stdout: Bool = false

    static let discussion: String = """
A simple text format for the notation of lyrics with chords.

See https://www.chordpro.org
"""

    static let configuration = CommandConfiguration(
        commandName: "chordprovider", // defaults to the type name, hyphen-separated and lowercase
        abstract: "Convert a ChordPro song into another format",
        // usage: "When nil, generates it based on the name, arguments, flags and options",
        discussion: discussion,
    )

    mutating func run() async throws {

        var settings = HtmlSettings()
        settings.options.lyricOnly = lyricsOnly

        let url = URL(filePath: source)
        var destination = url
        if let output {
            destination = URL(fileURLWithPath: output)
        } else {
            destination = url.deletingPathExtension().appendingPathExtension(format.rawValue)
        }

        let parsedSong = try await SongFileUtils.parseSongFile(fileURL: url, instrument: .guitar, prefixes: [], getOnlyMetadata: false)

        let fileManager = FileManager.default

        var result: String = "Error"

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
        if stdout {
            print (result)
        } else {
            /// Remove previous export (if any)
            try? fileManager.removeItem(atPath: destination.path)
            try? result.write(to: destination, atomically: true, encoding: String.Encoding.utf8)

            let messages = LogUtils.shared.fetchLog().map {message in

                var line = message.type.rawValue + ": " + message.category.rawValue + ": "
                if let lineNumber = message.lineNumber {
                    line += "line \(lineNumber): "
                }

                return line + message.message
            }
                .joined(separator: "\n")

            print(messages)
            print("Converted \(url.lastPathComponent) to \(destination.lastPathComponent)")
        }
    }
}
