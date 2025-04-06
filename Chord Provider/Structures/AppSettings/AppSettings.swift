//
//  AppSettings.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

/// All the settings for the application
struct AppSettings: Equatable, Codable, Sendable {
    /// Settings that will change the behaviour of the application
    var application = Application()
    /// The options for displaying a ``Song``
    var song = Song()
    /// The options for the ``ChordProEditor``
    var editor: Editor.Settings = .init()
    /// ChordPro integration
    var chordPro: ChordPro = .init()
    /// Style settings
    var style: Style = .init()
    /// PDF settings
    var pdf = AppSettings.PDF()
}

extension AppSettings {

    /// ChordPro integration
    struct ChordPro: Codable, Equatable {
        /// Bool to use the ChordPro CLI for PDF creation
        var useChordProCLI: Bool = false
        /// Bool to use **Chord Provider** settings
        var useChordProviderSettings: Bool = true
        /// Bool to use a custom config instead of system
        var useCustomConfig: Bool = false
        /// Bool to use an additional library
        var useAdditionalLibrary: Bool = false
    }
}

extension AppSettings {

    /// Load the application settings
    /// - Parameter id: The ID of the settings
    /// - Returns: The ``AppSettings``
    static func load(id: AppSettings.AppWindowID) -> AppSettings {
        if let settings = try? Cache.get(key: "ChordProviderSettings-\(id.rawValue)", struct: AppSettings.self) {
            return settings
        }
        /// No settings found; return defaults
        return AppSettings()
    }

    /// Save the application settings to the cache
    /// - Parameter id: The ID of the settings
    /// - Parameter settings: The ``AppSettings``
    static func save(id: AppSettings.AppWindowID, settings: AppSettings) throws {
        do {
            try Cache.set(key: "ChordProviderSettings-\(id.rawValue)", object: settings)
            Logger.application.info("**\(id.rawValue, privacy: .public)** saved")
        } catch {
            Logger.application.error("Error saving **\(id.rawValue, privacy: .public)**")
            throw AppError.saveSettingsError
        }
    }
}
