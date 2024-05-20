//
//  ChordProEditor+Regex.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import RegexBuilder

extension ChordProEditor {

    struct Regexes {

        /// All the directives we know about
        static let directives = ChordPro.Directive.allCases.map(\.rawValue)

        /// Regex for a chord
        let chordRegex = Regex {
            "["
            OneOrMore {
                CharacterClass(
                    .anyOf("[] ").inverted
                )
            }
            "]"
        }

        /// Regex for a directive
        let directiveRegex = Regex {
            Regex {
                "{"
                Capture {
                    ChoiceOf(directives)
                } transform: {
                    ChordPro.Directive(rawValue: $0.lowercased())
                }
                One(.anyOf(":}"))
            }
        }

        /// Regex for an optional directive definition
        let definitionRegex = Regex {
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
        let bracketRegex = Regex {
            Capture {
                OneOrMore {
                    CharacterClass(
                        .anyOf("[]{}")
                    )
                }
            }
        }
    }
}
