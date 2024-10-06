//
//  AppSettings.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

/// All the settings for the application
struct AppSettings: Equatable, Codable, Sendable {
    /// The options for displaying a ``Song``
    var song = SongDisplayOptions()
    /// The options for displacing a ``ChordDefinition``
    var diagram = DiagramDisplayOptions()
    /// The options for the ``ChordProEditor``
    var editor: ChordProEditor.Settings = .init()
}

extension AppSettings {

    /// Load the application settings
    /// - Parameter id: The ID of the settings
    /// - Returns: The ``ChordProviderSettings``
    static func load(id: AppStateModel.AppStateID) -> AppSettings {
        if let settings = try? Cache.get(key: "ChordProviderSettings-\(id.rawValue)", struct: AppSettings.self) {
            return settings
        }
        /// No settings found; return defaults
        return AppSettings()
    }

    /// Save the application settings to the cache
    /// - Parameter id: The ID of the settings
    /// - Parameter settings: The ``ChordProviderSettings``
    static func save(id: AppStateModel.AppStateID, settings: AppSettings) throws {
        do {
            try Cache.set(key: "ChordProviderSettings-\(id.rawValue)", object: settings)
            Logger.application.info("\(id.rawValue, privacy: .public) saved")
        } catch {
            Logger.application.error("Error saving ChordProvider settings")
            throw AppError.saveSettingsError
        }
    }
}
