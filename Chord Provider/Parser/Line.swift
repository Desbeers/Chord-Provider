//
//  Line.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Song.Section {
    
    /// A line in the ``Song``
    struct Line {
        var parts = [Part]()
        var measures = [Measure]()
        var tablature: String?
        var comment: String?
        var plain: String?
    }
}
