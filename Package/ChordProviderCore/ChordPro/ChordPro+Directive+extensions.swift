//
//  ChordPro+Directive+extensions.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    // MARK: Directive extensions

    /// The start and end of the directive
    public func format(wrap: Bool) -> (start: String, end: String, block: Bool) {
        switch self {
            // MARK: Block elements
        case .startOfChorus:
            ("{\(label(.startOfChorus))}\n", "\n{\(label(.endOfChorus))}", true)
        case .startOfVerse:
            ("{\(label(.startOfVerse))}\n", "\n{\(label(.endOfVerse))}", true)
        case .startOfBridge:
            ("{\(label(.startOfBridge))}\n", "\n{\(label(.endOfBridge))}", true)
        case .startOfTab:
            ("{\(label(.startOfTab))}\n", "\n{\(label(.endOfTab))}", true)
        case .startOfGrid:
            ("{\(label(.startOfGrid))}\n", "\n{\(label(.endOfGrid))}", true)
        case .startOfTextblock:
            ("{\(label(.startOfTextblock))}\n", "\n{\(label(.endOfTextblock))}", true)
            // MARK: Inline elements
        case .chorus:
            /// - Note: The chorus can have an optional label
            switch wrap {
            case true:
                ("{\(label(.chorus)): ", "}", false)
            case false:
                ("{\(label(.chorus))", "}\n", false)
            }
        default:
            ("{\(self.source.long)\(ChordPro.Directive.withPlainArgument.contains(self) ? ":" : "") ", "}", false)
        }
    }

    /// The raw label of the directive
    /// - Parameter directive: The ``ChordPro/Directive``
    /// - Returns: The raw value as `String`
    func label(_ directive: ChordPro.Directive) -> String {
        directive.source.long
    }
}

extension ChordPro.Directive {

    // MARK: Grouped directives

    /// Array of unsupported ``ChordPro/Directive``
    public static var unsupportedDirectives: [ChordPro.Directive] {
        customDirectives +
        [
            .startOfLy,
            .endOfLy,
            .startOfABC,
            .endOfABC,
            .startOfSvg,
            .endOfSvg,
            .highlight,
            .commentItalic,
            .commentBox,
            .columnBreak,
            .newPage
        ]
    }

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
            .tag,
            .transpose,
            .copyright,
            .duration,
            .arranger,
            .lyricist
        ]
    }

    /// Array of ``ChordPro/Directive`` that **must** have a *plain* argument
    public static var withPlainArgument: [ChordPro.Directive] {
        metadataDirectives + [
            .define,
            .defineGuitar,
            .defineUkulele,
            .defineGuitalele,
            .chord,
            .comment
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
            .startOfTextblock
        ]
    }

    /// Array of ``ChordPro/Directive`` that can be edited by double click on it
    static var editableDirectives: [ChordPro.Directive] {
        metadataDirectives + environmentDirectives + [
            .subtitle,
            .comment,
            .highlight,
            .define,
            .defineGuitar,
            .defineGuitalele,
            .defineUkulele,
            .image
        ]
    }

    /// Array of ``ChordPro/Directive`` that should only defined once
    static var singleDirectives: [ChordPro.Directive] {
        [
            .title,
            .sortTitle,
            .subtitle,
            .artist,
            .sortArtist,
            .album,
            .year,
            .key,
            .time,
            .capo,
            .transpose,
            .copyright,
            .duration
        ]
    }

    /// Array of  custom **environment** ``ChordPro/Directive``
    static public var customDirectives: [ChordPro.Directive] {
        [
            .sourceComment,
            .emptyLine,
            .unknown
        ]
    }
}
