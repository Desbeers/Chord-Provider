//
//  AppSettings+ChordProCLI.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

extension AppSettings {

    /// Settings for the official **ChordPro** CLI integration
    struct ChordProCLI: Codable, Equatable {
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
