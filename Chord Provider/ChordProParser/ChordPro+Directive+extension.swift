//
//  EditorView+Directive.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    /// The start and end of the directive
    var format: (start: String, end: String) {
        switch self {
            // MARK: Block elements
        case .startOfChorus:
            ("{\(label(.startOfChorus))}\n", "\n{\(label(.endOfChorus))}")
        case .startOfVerse:
            ("{\(label(.startOfVerse))}\n", "\n{\(label(.endOfVerse))}")
        case .startOfBridge:
            ("{\(label(.startOfBridge))}\n", "\n{\(label(.endOfBridge))}")
        case .startOfTab:
            ("{\(label(.startOfTab))}\n", "\n{\(label(.endOfTab))}")
        case .startOfGrid:
            ("{\(label(.startOfGrid))}\n", "\n{\(label(.endOfGrid))}")
        case .startOfTextblock:
            ("{\(label(.startOfTextblock))}\n", "\n{\(label(.endOfTextblock))}")
        case .startOfStrum:
            ("{\(label(.startOfStrum))}\n", "\n{\(label(.endOfStrum))}")
            // MARK: Inline elements
        case .chorus:
            /// - Note: The chorus can have an optional label
            ("{\(label(.chorus))", "}\n")
        default:
            ("{\(self.rawValue): ", "}\n")
        }
    }

    /// The raw label of the directive
    /// - Parameter directive: The ``ChordPro/Directive``
    /// - Returns: The raw value as `String`
    func label(_ directive: ChordPro.Directive) -> String {
        directive.rawValue
    }

    /// The kind of directive (block or inline)
    ///
    /// - Note: This is used to move the cursor in the editor when you apply a directive to selected text in the editor
    var kind: Kind {
        switch self {
        case .startOfChorus, .startOfVerse, .startOfBridge, .startOfTab, .startOfGrid, .startOfTextblock, .define:
            return .block
        case .chorus:
            return .optionalLabel
        default:
            return .inline
        }
    }

    /// The kind of directive (block or inline)
    enum Kind {
        /// The directive is wrapped around text; e.g. **{start_of_chorus}Lalala!{end_of_chorus}**
        case block
        /// The directive is inline, e.g. **{comment: Hello World!}**
        case inline
        /// The directive can have an optional label; e.g.**{chorus: Repeat}** or jusr **{chorus}**
        case optionalLabel
    }
}

extension ChordPro.Directive {

    /// Array of **Metadata** ``ChordPro/Directive``
    static var metaDataDirectives: [ChordPro.Directive] {
        [
            .title,
            .artist,
            .album,
            .year,
            .key,
            .time,
            .tempo,
            .capo,
            .tag,
            .musicPath
        ]
    }

    /// Array of **environment** ``ChordPro/Directive``
    static var environmentDirectives: [ChordPro.Directive] {
        [
            .startOfVerse,
            .startOfChorus,
            .chorus,
            .startOfTab,
            .startOfGrid,
            .startOfBridge,
            .startOfTextblock,
            .startOfStrum
        ]
    }

    /// Array of ``ChordPro/Directive`` that can be edited by double click on it (macOS only)
    static var editableDirectives: [ChordPro.Directive] {
        metaDataDirectives + environmentDirectives + [
            .sov,
            .soc,
            .sot,
            .sog,
            .sob,
            .sos,
            .t,
            .st,
            .subtitle,
            .comment,
            .define
        ]
    }
}
