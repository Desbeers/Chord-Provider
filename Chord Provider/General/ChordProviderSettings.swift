//
//  ChordProviderSettings.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyStructCache
import SwiftlyChordUtilities
import OSLog

/// Structure with all the Chord Provider Settings
struct ChordProviderSettings: Equatable, Codable, Sendable {
    var showChords: Bool = true
    var showInlineDiagrams: Bool = false
    var paging: Song.DisplayOptions.Paging = .asList
    var chordsPosition: Position = .right

    var general = ChordProviderGeneralOptions()
    var editor: ChordProviderSettings.Editor = .init()

    enum Position: String, CaseIterable, Codable {
        case right = "Right"
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
