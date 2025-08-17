//
//  ChordPro+Directive+extensions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    // MARK: Directive extensions

    /// The start and end of the directive
    public var format: (start: String, end: String) {
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
            ("{\(label(.chorus))", "}")
        default:
            ("{\(self.rawValue.long) ", "}")
        }
    }

    /// The raw label of the directive
    /// - Parameter directive: The ``ChordPro/Directive``
    /// - Returns: The raw value as `String`
    func label(_ directive: ChordPro.Directive) -> String {
        directive.rawValue.long
    }

    /// The kind of directive (block, inline or optional label)
    public var kind: Kind {
        switch self {
        case .startOfChorus, .startOfVerse, .startOfBridge, .startOfTab, .startOfGrid, .startOfTextblock, .define:
            return .block
        case .chorus:
            return .optionalLabel
        default:
            return .inline
        }
    }

    /// The kind of directive (block, inline or optional label)
    public enum Kind {
        /// The directive is wrapped around text; e.g. **{start_of_chorus}[G7]Lalala!{end_of_chorus}**
        case block
        /// The directive is inline, e.g. **{comment Hello World!}**
        case inline
        /// The directive can have an optional label; e.g.**{chorus Repeat}** or just **{chorus}**
        case optionalLabel
    }
}

extension ChordPro.Directive {

    // MARK: Grouped directives

    /// Array of **Metadata** ``ChordPro/Directive``
    public static var metadataDirectives: [ChordPro.Directive] {
        [
            .title,
            .sortTitle,
            .subtitle,
            .artist,
            .sortArtist,
            .composer,
            .album,
            .year,
            .key,
            .time,
            .tempo,
            .capo,
            .tag
        ]
    }

    /// Array of **environment** ``ChordPro/Directive``
    public static var environmentDirectives: [ChordPro.Directive] {
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

    /// Array of ``ChordPro/Directive`` that can be edited by double click on it
    static var editableDirectives: [ChordPro.Directive] {
        metadataDirectives + environmentDirectives + [
            .subtitle,
            .comment,
            .define,
            .image
        ]
    }

    /// Array of  custom **environment** ``ChordPro/Directive``
    static var customDirectives: [ChordPro.Directive] {
        [
            .sourceComment,
            .emptyLine,
            .unknown
        ]
    }
}
