//
//  AppSettings.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

/// All the settings for **Chord Provider**
struct AppSettings: Equatable, Codable, Sendable {
    /// Settings that will change the behaviour of the application
    var application = Application()
    /// Settings shared by all scenes
    var shared = Shared()
    /// The options for displaying a ``Song``
    var display = Display()
    /// The options for displaying a ``ChordDefinition``
    var diagram = Diagram()
    /// The options for the ``ChordProEditor``
    var editor: Editor.Settings = .init()
    /// Settings for the official **ChordPro** CLI integration
    var chordProCLI: ChordProCLI = .init()
    /// Settings for the colors and fonts for displaying a song
    var style: Style = .init() {
        didSet {
            /// Set some styles based on foreground colors
            style.fonts.title.color = style.theme.foreground
            style.fonts.subtitle.color = style.theme.foregroundMedium
            style.fonts.text.color = style.theme.foreground
        }
    }
    /// Settings for PDF song or folder export
    var pdf = AppSettings.PDF()

    // MARK: Scaling

    /// Max width of the `View`
    var maxWidth: Double = 340
    /// Scale magnifier
    var scale: Double = 1
}

extension AppSettings {

    /// Load the application settings
    /// - Parameter id: The ID of the settings
    /// - Returns: The ``AppSettings``
    static func load(id: AppSettings.AppWindowID) -> AppSettings {
        if let settings = try? SettingsCache.get(id: id, struct: AppSettings.self) {
            return settings
        }
        /// No settings found; return defaults
        Logger.application.info("No **\(id.rawValue, privacy: .public)** found; using defaults")
        var appSettings = AppSettings()
        appSettings.style = AppSettings.Style().defaults()
        /// Save settings
        try? save(id: id, settings: appSettings)
        return appSettings
    }

    /// Save the application settings to the cache
    /// - Parameter id: The ID of the settings
    /// - Parameter settings: The ``AppSettings``
    static func save(id: AppSettings.AppWindowID, settings: AppSettings) throws {
        do {
            try SettingsCache.set(id: id, object: settings)
            Logger.application.info("**\(id.rawValue, privacy: .public)** saved")
        } catch {
            Logger.application.error("Error saving **\(id.rawValue, privacy: .public)**")
            throw AppError.saveSettingsError
        }
    }
}
