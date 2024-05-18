//
//  ChordProEditor+Regex.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import RegexBuilder

extension ChordProEditor {

    /// All the directives we know about
    static let directives = ChordPro.Directive.allCases.map(\.rawValue)

    /// Regex for a chord
    static let chordRegex = Regex {
        "["
        OneOrMore {
            CharacterClass(
                .anyOf("[] ").inverted
            )
        }
        "]"
    }

    /// Regex for a directive
    static let directiveRegex = Regex {
        Regex {
            "{"
            Capture {
                ChoiceOf(ChordProEditor.directives)
            } transform: {
                ChordPro.Directive(rawValue: $0.lowercased())
            }
            One(.anyOf(":}"))
        }
    }

    /// Regex for an optional directive definition
    static let definitionRegex = Regex {
        ":"
        Capture {
            OneOrMore {
                CharacterClass(
                    .anyOf("{}").inverted
                )
            }
        }
        "}"
    }

    /// Regex for brackets for chords and directives
    static let bracketRegex = Regex {
        Capture {
            OneOrMore {
                CharacterClass(
                    .anyOf("[]{}")
                )
            }
        }
    }
}
