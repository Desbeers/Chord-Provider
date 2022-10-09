//
//  Line.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Song.Section {
    
    /// A line in the ``Song``
    struct Line: Identifiable {
        var id: Int
        var parts = [Part]()
        var grid = [Grid]()
        var tab: String = ""
    }
}
