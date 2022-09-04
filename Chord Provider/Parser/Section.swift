//
//  Section.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Song {
    
    /// A section of the ``Song``
    struct Section {
        var name: String?
        var type: String?
        var lines = [Line]()
    }
}
