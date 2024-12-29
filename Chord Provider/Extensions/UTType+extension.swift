//
//  UTType+extension.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import UniformTypeIdentifiers

extension UTType {

    // MARK: The `UTType` for a `ChordPro` song

    /// The `UTType` for a ChordPro song
    static let chordProSong =
    UTType(importedAs: "org.chordpro")
}
