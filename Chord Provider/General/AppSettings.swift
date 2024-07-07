//
//  AppSettings.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities
import OSLog
import ChordProShared

/// All the settings for the application
struct AppSettings: Equatable, Codable, Sendable {

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

extension AppSettings {

    /// Load the application settings
    /// - Parameter id: The ID of the settings
    /// - Returns: The ``ChordProviderSettings``
    static func load(id: String) -> AppSettings {
        if let settings = try? Cache.get(key: "ChordProviderSettings-\(id)", struct: AppSettings.self) {
            return settings
        }
        /// No settings found; return defaults
        return AppSettings()
    }

    /// Save the application settings to the cache
    /// - Parameter id: The ID of the settings
    /// - Parameter settings: The ``ChordProviderSettings``
    static func save(id: String, settings: AppSettings) throws {
        do {
            try Cache.set(key: "ChordProviderSettings-\(id)", object: settings)
            Logger.application.info("\(id, privacy: .public) saved")
        } catch {
            Logger.application.error("Error saving ChordProvider settings")
            throw AppError.saveSettingsError
        }
    }
}
