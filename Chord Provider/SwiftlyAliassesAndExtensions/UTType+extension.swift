//
//  UTType+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import UniformTypeIdentifiers

extension UTType {

    // MARK: The `UTType` for a `ChordPro` document

    /// The `UTType` for a ChordPro document
    static let chordProDocument =
    UTType(importedAs: "org.chordpro")
}
