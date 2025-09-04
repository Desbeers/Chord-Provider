//
//  ChordProviderSettings.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

public struct ChordProviderSettings {
    public init(
        instrument: Chord.Instrument = .guitar,
        lyricOnly: Bool = false,
        repeatWholeChorus: Bool = false
    ) {
        self.instrument = instrument
        self.lyricOnly = lyricOnly
        self.repeatWholeChorus = repeatWholeChorus
    }
    /// The instrument for the song
    public var instrument: Chord.Instrument = .guitar
    /// Show only lyrics
    public var lyricOnly: Bool
    /// Repeat the whole last chorus when using a *{chorus}* directive
    public var repeatWholeChorus: Bool
    /// Export settings
    public var exportSettings = Export()
    /// The URL of the current song
    public var songURL: URL?
    /// The initial name when exporting
    public var initialName: String {
        var name = songURL?.deletingPathExtension().lastPathComponent ?? "Untitled"
        /// Add the extension
        name.append(".\(exportSettings.format.rawValue)")
        return name
    }
}
