//
//  ChordPro+Environment+extensions.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordPro.Environment {

    /// The directives for opening and closing an environment
    var directives: (open: ChordPro.Directive, close: ChordPro.Directive) {
        switch self {
        case .chorus:
            (.startOfChorus, .endOfChorus)
        case .verse:
            (.startOfVerse, .endOfVerse)
        case .bridge:
            (.startOfBridge, .endOfBridge)
        case .tab:
            (.startOfTab, .endOfTab)
        case .grid:
            (.startOfGrid, .endOfGrid)
        case .abc:
            (.startOfABC, .endOfABC)
        case .textblock:
            (.startOfTextblock, .endOfTextblock)
        default:
            (.unknown, .unknown)
        }
    }
}
