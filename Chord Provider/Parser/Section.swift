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
        var name: String?
        var type: SectionType?
        var autoType: Bool = false
        var lines = [Line]()
        /// The type of the section
        enum SectionType: String {
            case chorus
            case repeatChorus
            case verse
            case bridge
            case comment
            case tab
            case grid
        }
    }
}
