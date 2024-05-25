//
//  ChordProviderSettings.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyStructCache
import SwiftlyChordUtilities
import OSLog

/// Structure with all the **Chord Provider** settings
struct ChordProviderSettings: Equatable, Codable, Sendable {
    /// Show the chord diagrams
    var showChords: Bool = true
    /// Show the chord diagrams inline with the song text
    var showInlineDiagrams: Bool = false
    /// The paging style for the ``SongView``
    var paging: Song.DisplayOptions.Paging = .asList
    /// The position for the chord diagrams
    var chordsPosition: Position = .right
    /// General options (shared with the quickview plugins)
    var general = ChordProviderGeneralOptions()
    /// The options for the ``ChordProEditor``
    var editor: ChordProEditor.Settings = .init()

    /// Possible positions for the chord diagrams
    enum Position: String, CaseIterable, Codable {
        /// Show diagrams on the right of the `View`
        case right = "Right"
        /// Show diagrams as the bottom of the `View`
        case bottom = "Bottom"
    }
    /// Default Chord Display Options
    static let defaults = ChordDefinition.DisplayOptions(
        showName: true,
        showNotes: true,
        showPlayButton: true,
        rootDisplay: .symbol,
        qualityDisplay: .symbolized,
        showFingers: true,
        mirrorDiagram: false
    )
}

extension ChordProviderSettings {

    /// Load the Chord Provider settings
    /// - Returns: The ``ChordProviderSettings``
    static func load() -> ChordProviderSettings {
        if let settings = try? Cache.get(key: "ChordProviderSettings", as: ChordProviderSettings.self) {
            return settings
        }
        /// No settings found; return defaults
        return ChordProviderSettings()
    }

    /// Save the Chord Provider settings to the cache
    /// - Parameter settings: The ``ChordProviderSettings``
    static func save(settings: ChordProviderSettings) throws {
        do {
            try Cache.set(key: "ChordProviderSettings", object: settings)
        } catch {
            Logger.application.error("Error saving ChordProvider settings")
            throw ChordProviderError.saveSettingsError
        }
    }
}
