//
//  Editor+Directive.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Editor {
    
    /// ChordPro directives
    enum Directive {
        case chorus
        case verse
        case comment
        case chordDefine
        /// The start and end of the directive
        var format: (start: String, end: String) {
            switch self {
            case .chorus:
                return ("{start_of_chorus}\n", "\n{end_of_chorus}\n")
            case .verse:
                return ("{start_of_verse}\n", "\n{end_of_verse}\n")
            case .comment:
                return ("{comment: ", "}")
            case .chordDefine:
                return ("{define: [chord] base-fret [offset] frets [pos] fingers [pos]", "}")
            }
        }
        /// The kind of directive (block or inline)
        ///
        /// - Note: This is used to move the cursor in the editor when you apply a directive to selected text in the editor
        var kind: Kind {
            switch self {
            case .chorus, .verse, .chordDefine:
                return .block
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
        }
    }
}
