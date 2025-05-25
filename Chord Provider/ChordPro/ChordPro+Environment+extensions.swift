//
//  ChordPro+Environment+extensions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
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

extension ChordPro.Environment {

    /// The default label for the environment
    var label: String {
        switch self {
        case .chorus:
            "Chorus"
        case .repeatChorus:
            ""
        case .verse:
            "Verse"
        case .bridge:
            "Bridge"
        case .comment:
            ""
        case .tab:
            ""
        case .grid:
            ""
        case .abc:
            "ABC"
        case .textblock:
            ""
        case .strum:
            ""
        case .metadata:
            "Metadata"
        case .image:
            "Image"
        case .none:
            "None"
        }
    }
}

extension ChordPro.Environment {

    /// Unsupported environments for the output
    static var unsupported: [ChordPro.Environment] {
        [
            .metadata,
            .abc,
            .none
        ]
    }
}
