//
//  Song+MetaData.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension Song {

    /// Meta data about the song
    struct MetaData {

        // MARK: Meta-data directives

        /// The optional title
        var title: String?
        /// The optional artist
        var artist: String?
        /// The optional capo
        var capo: String?
        /// The optional key
        var key: ChordDefinition?
        /// The optional tempo
        var tempo: String?
        /// The optional time
        var time: String?
        /// The optional year
        var year: String?
        /// The optional album
        var album: String?
        /// The optional tuning
        var tuning: String?
        /// The optional path to the audio file
        var musicPath: String?
        /// The optional tag(s)
        var tags: [String] = []
        /// The optional transpose
        var transpose: Int = 0
        /// The instrument
        var instrument: Instrument = .guitarStandardETuning

        /// The optional file URL
        var fileURL: URL?

        // MARK: Song export

        /// The location for the PDF export
        var exportURL: URL {
            return FileManager.default.temporaryDirectory
                .appendingPathComponent(exportName, conformingTo: .pdf)
        }

        /// The default name for the export
        var exportName: String {
            "\(artist ?? "Artist") - \(title ?? "Title")"
        }
    }
}

extension ChordPro.Directive {

    // MARK: Symbols

    /// The symbol for a meta data item
    /// - Note: The sfSymbol is for SwiftUI and the literal for PDF export
    var symbol: (sfSymbol: String, literal: String) {
        switch self {
        case .time:
            ("timer", "􀐱")
        case .capo:
            ("paperclip", "􀉢")
        case .instrument:
            ("guitars", "􀑭")
        default:
            ("questionmark", "􀅍")
        }
    }
}
