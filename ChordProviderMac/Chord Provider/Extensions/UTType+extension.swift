//
//  UTType+extension.swift
//  Chord Provider
//
//  © 2026 Nick Berendsen
//

import Foundation
import UniformTypeIdentifiers

extension UTType {

    /// The `UTType` for a ChordPro song
    static let chordProSong = UTType(importedAs: "org.chordpro.chordpro")

    /// The `UTType` for a BASIC song
    static let basicSong = UTType(importedAs: "nl.desbeers.chordprovider.basic")
}
