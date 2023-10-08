//
//  ChordProviderSettings.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyStructCache
import SwiftlyChordUtilities

/// Structure with all the Chord Provider Settings
struct ChordProviderSettings: Equatable, Codable {
    var showChords: Bool = true
    var showInlineDiagrams: Bool = false
    var paging: Song.DisplayOptions.Paging = .asList
    var editorFontSize: Int = 14
    var chordsPosition: Position = .right

    enum Position: String, CaseIterable, Codable {
        case right = "Right"
        case bottom = "Bottom"
    }
}

extension ChordProviderSettings {

    /// Load the Chord Provider settings
    /// - Returns: The ``ChordProviderSettings``
    static func load() -> ChordProviderSettings {
        if let hosts = try? Cache.get(key: "ChordProviderSettings", as: ChordProviderSettings.self) {
            return hosts
        }
        /// No settings found
        return ChordProviderSettings()
    }

    /// Save the Chord Provider settings to the cache
    /// - Parameter settings: The ``ChordProviderSettings``
    static func save(settings: ChordProviderSettings) {
        do {
            try Cache.set(key: "ChordProviderSettings", object: settings)
        } catch {
            print("Error saving ChordProvider settings")
        }
    }
}
