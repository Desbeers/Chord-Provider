//
//  ChordProviderSettings.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities
import OSLog

/// Structure with all the **Chord Provider** settings
struct ChordProviderSettings: Equatable, Codable, Sendable {

    /// The options for the ``ChordProEditor``
    var editor: ChordProEditor.Settings = .init()

    /// Song Display Options
    var songDisplayOptions = Song.DisplayOptions()

    /// Chord Display Options
    var chordDisplayOptions = ChordDefinition.DisplayOptions()

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
    /// - Parameter id: The ID of the settings
    /// - Returns: The ``ChordProviderSettings``
    static func load(id: String) -> ChordProviderSettings {
        if let settings = try? Cache.get(key: "ChordProviderSettings-\(id)", struct: ChordProviderSettings.self) {
            return settings
        }
        /// No settings found; return defaults
        return ChordProviderSettings()
    }

    /// Save the Chord Provider settings to the cache
    /// - Parameter id: The ID of the settings
    /// - Parameter settings: The ``ChordProviderSettings``
    static func save(id: String, settings: ChordProviderSettings) throws {
        do {
            try Cache.set(key: "ChordProviderSettings-\(id)", object: settings)
            Logger.application.info("\(id, privacy: .public) saved")
        } catch {
            Logger.application.error("Error saving ChordProvider settings")
            throw AppError.saveSettingsError
        }
    }
}
