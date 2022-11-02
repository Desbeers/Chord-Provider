//
//  Section.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Song {
    
    /// A section of the ``Song``
    struct Section: Identifiable {
        var id: Int
        var label: String?
        var type: ChordPro.Environment = .none
        var autoType: Bool = false
        var lines = [Line]()
    }
}
