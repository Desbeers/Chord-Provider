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
        case .startOfChorus:
            return ("{\(label(.startOfChorus))}\n", "\n{\(label(.endOfChorus))}\n")
        case .startOfVerse:
            return ("{\(label(.startOfVerse))}\n", "\n{\(label(.endOfVerse))}\n")
        case .startOfBridge:
            return ("{\(label(.startOfBridge))}\n", "\n{\(label(.endOfBridge))}\n")
        case .startOfTab:
            return ("{\(label(.startOfTab))}\n", "\n{\(label(.endOfTab))}\n")
        case .startOfGrid:
            return ("{\(label(.startOfGrid))}\n", "\n{\(label(.endOfGrid))}\n")
        case .comment:
            return ("{\(label(.comment)): ", "}\n")
        case .define:
            return ("{\(label(.define)): [chord] base-fret [offset] frets [pos] fingers [pos]", "}\n")
        case .chorus:
            return ("{\(label(.chorus))", "}\n")
        default:
            return ("{NOT IMPLEMENTED", "}\n")
        }
        /// The formatted label of the directive
        func label(_ directive: ChordPro.Directive) -> String {
            directive.rawValue
        }
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
        /// The directive is wrapped around text; e.g. *{start_of_chorus}LALALA!{end_of_chorus}*
        case block
        /// The directive is inline, e.g. *{comment: Hello World!}*
        case inline
        /// The directive can have an optional label
        case optionalLabel
    }
    /// The label for the button
    var label: (text: String, icon: String) {
        switch self {
        case .startOfChorus:
            return ("Chorus", "music.note.list")
        case .chorus:
            return ("Repeat Chorus", "repeat")
        case .startOfVerse:
            return ("Verse", "music.mic")
        case .startOfBridge:
            return ("Bridge", "music.mic")
        case .startOfTab:
            return ("Tab", "music.mic")
        case .startOfGrid:
            return ("Grid", "music.mic")
        case .comment:
            return ("Comment", "cloud")
        case .define:
            return ("Define", "music.note.list")
        default:
            return ("NOT IMPLEMENTED", "questionmark.app")
        }
    }
}
