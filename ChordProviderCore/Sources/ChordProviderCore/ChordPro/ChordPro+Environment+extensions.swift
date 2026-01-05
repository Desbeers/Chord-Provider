//
//  ChordPro+Environment+extensions.swift
//  ChordProviderCore
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
        case .strum:
            (.startOfStrum, .endOfStrum)
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
            "Repeat Chorus"
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
            ""
        case .image:
            ""
        case .emptyLine:
            ""
        case .sourceComment:
            ""
        case .none:
            ""
        }
    }
}

extension ChordPro.Environment {

    /// Unsupported environments for the output
    public static var unsupported: [ChordPro.Environment] {
        [
            .metadata,
            .abc,
            .sourceComment,
            .none
        ]
    }

    /// Environments with song content
    public static var content: [ChordPro.Environment] {
        [
            .metadata,
            .chorus,
            .repeatChorus,
            .verse,
            .bridge,
            .tab,
            .grid,
            .strum,
            .textblock,
            .comment,
            .image
        ]
    }
}
