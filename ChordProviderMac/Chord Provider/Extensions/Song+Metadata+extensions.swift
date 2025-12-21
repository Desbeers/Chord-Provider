//
//  Song+Metadata+extensions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension Song.Metadata {

    // MARK: URL's

    /// The URL of the source file
    var sourceURL: URL {
        ChordProviderSettings.temporaryDirectoryURL.appendingPathComponent(exportName, conformingTo: .chordProSong)
    }

    /// The URL of the export PDF
    var exportURL: URL {
        ChordProviderSettings.temporaryDirectoryURL.appendingPathComponent(exportName, conformingTo: .pdf)
    }

    /// The URL of the basic file
    var basicURL: URL {
        ChordProviderSettings.temporaryDirectoryURL.appendingPathComponent("basic", conformingTo: .plainText)
    }

    /// The URL of the basic file in prg format
    var basicProgramURL: URL {
        ChordProviderSettings.temporaryDirectoryURL.appendingPathComponent("basic.prg")
    }
}
