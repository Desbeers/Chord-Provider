//
//  Song+Metadata+chordProCLI.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension Song.Metadata {

    // MARK: ChordPro CLI integration

    /// The URL of the default config file
    var defaultConfigURL: URL {
        let fileName = "ChordProviderDefaults"
        /// Create an export URL
        return Song.temporaryDirectoryURL.appendingPathComponent(fileName, conformingTo: .json)
    }

    /// The URL of the config file with details
    var configURL: URL {
        let fileName = "ChordProvider"
        /// Create an export URL
        return Song.temporaryDirectoryURL.appendingPathComponent(fileName, conformingTo: .json)
    }

    /// The optional local configuration (a config named `chordpro.json` next to a song)
    var localSystemConfigURL: URL? {
        if let file = fileURL {
            let systemConfig = file.deletingLastPathComponent().appendingPathComponent("chordpro", conformingTo: .json)
            if FileManager.default.fileExists(atPath: systemConfig.path) {
                return systemConfig
            }
            return nil
        }
        return nil
    }

    /// The optional local configuration (a config with the same base-name next to a song)
    var localSongConfigURL: URL? {
        if let file = fileURL {
            let localConfig = file.deletingPathExtension().appendingPathExtension("json")
            let haveConfig = FileManager.default.fileExists(atPath: localConfig.path)
            return haveConfig ? localConfig : nil
        }
        if let templateURL {
            let templateConfig = templateURL.deletingPathExtension().appendingPathExtension("json")
            let haveConfig = FileManager.default.fileExists(atPath: templateConfig.path)
            return haveConfig ? templateConfig : nil
        }
        return nil
    }
}
