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
            ChoiceOf(ChordProEditor.directives)
            One(.anyOf(":}"))
        }
    }

    /// Regex for an optional directive definition
    static let definitionRegex = Regex {
        ":"
        OneOrMore {
            CharacterClass(
                .anyOf("{}").inverted
            )
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

extension ChoiceOf where RegexOutput == Substring {

    /// Extension to use an array of elements for a `ChoiceOf` regex part
    /// - Parameter components: The choices components
    init<S: Sequence<String>>(_ components: S) {
        let exps = components.map { AlternationBuilder.buildExpression($0) }

        guard !exps.isEmpty else {
            fatalError("Empty choice!")
        }

        self = exps.dropFirst().reduce(AlternationBuilder.buildPartialBlock(first: exps[0])) { acc, next in
            AlternationBuilder.buildPartialBlock(accumulated: acc, next: next)
        }
    }
}
