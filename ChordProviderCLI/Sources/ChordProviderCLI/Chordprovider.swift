// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser
import ChordProviderCore

@main
struct Chordprovider: AsyncParsableCommand {
    @Option(help: "The ChordPro song to parse.")
    public var source: String
    @Option(help: "The output format.")
    public var output: Output
    mutating func run() async throws {
        let url = URL(filePath: source)
        let parsedSong = try await SongFileUtils.parseSongFile(fileURL: url, instrument: .guitar, prefixes: [], getOnlyMetadata: false)

        switch output {
        case .json:
            let json = try JSONUtils.encode(parsedSong)
            print(json)
        case .source:
            print(parsedSong.content)
        }
    }
}
