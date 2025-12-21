//
//  ChordProviderSettings.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

public struct ChordProviderSettings: Equatable, Codable, Sendable {
    public init(
        instrument: Chord.Instrument = .guitar,
        lyricsOnly: Bool = false,
        repeatWholeChorus: Bool = false,
        transpose: Int = 0
    ) {
        self.instrument = instrument
        self.lyricsOnly = lyricsOnly
        self.repeatWholeChorus = repeatWholeChorus
        self.transpose = transpose
    }
    /// The instrument for the song
    public var instrument: Chord.Instrument = .guitar
    /// Show only lyrics
    public var lyricsOnly: Bool
    /// Repeat the whole last chorus when using a *{chorus}* directive
    public var repeatWholeChorus: Bool
    /// The optional transpose
    public var transpose: Int = 0
    /// Export settings
    public var export = Export()
    /// Diagram settings
    public var diagram = Diagram()
    /// The URL of the current **ChordPro** file
    public var fileURL: URL?
    /// The optional template URL
    public var templateURL: URL?
    /// List of articles to ignore when sorting songs and artists
    public var sortTokens: [String] = ["the", "a", "de", "een", "’t"]
    /// The initial name when exporting
    public var initialName: String {
        var name = fileURL?.deletingPathExtension().lastPathComponent ?? "Untitled"
        /// Add the extension
        name.append(".\(export.format.rawValue)")
        return name
    }
    /// The coding keys
    enum CodingKeys: CodingKey {
        case instrument
        case lyricsOnly
        case repeatWholeChorus
        case diagram
        case sortTokens
    }
    /// The temporary directory
    public static let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        .appendingPathComponent(Bundle.main.bundleIdentifier ?? "nl.desbeers.chordprovider", isDirectory: true)
}
