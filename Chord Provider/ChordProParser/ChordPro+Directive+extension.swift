//
//  EditorView+Directive.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    /// The start and end of the directive
    var format: (start: String, end: String) {
        switch self {
            // MARK: Block elements
        case .startOfChorus:
            ("{\(label(.startOfChorus))}\n", "\n{\(label(.endOfChorus))}\n")
        case .startOfVerse:
            ("{\(label(.startOfVerse))}\n", "\n{\(label(.endOfVerse))}\n")
        case .startOfBridge:
            ("{\(label(.startOfBridge))}\n", "\n{\(label(.endOfBridge))}\n")
        case .startOfTab:
            ("{\(label(.startOfTab))}\n", "\n{\(label(.endOfTab))}\n")
        case .startOfGrid:
            ("{\(label(.startOfGrid))}\n", "\n{\(label(.endOfGrid))}\n")
        case .startOfStrum:
            ("{\(label(.startOfStrum))}\n", "\n{\(label(.endOfStrum))}\n")
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
        case .startOfChorus, .startOfVerse, .startOfBridge, .startOfTab, .startOfGrid, .define:
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

    /// The label for the button
    var label: (text: String, icon: String) {
        switch self {
        case .startOfChorus:
            ("Chorus", "music.note.list")
        case .chorus:
            ("Repeat Chorus", "repeat")
        case .startOfVerse:
            ("Verse", "music.mic")
        case .startOfBridge:
            ("Bridge", "music.mic")
        case .startOfTab:
            ("Tab", "music.mic")
        case .startOfGrid:
            ("Grid", "music.mic")
        case .startOfStrum:
            ("Strumming", "music.mic")
        case .comment:
            ("Add a Comment", "cloud")
        case .define:
            ("Define a Chord", "music.note.list")
        default:
            ("\(self.rawValue.capitalized)", "pencil")
        }
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
            .tag
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
            .startOfStrum
        ]
    }
}
