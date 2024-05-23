//
//  ChordPro+Regex.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import RegexBuilder

extension ChordPro {

    // MARK: Regex definitions

    /// All the directives we know about
    static let directives = ChordPro.Directive.allCases.map(\.rawValue)

    /// The regex for a `directive` with an optional `label`
    ///
    ///     /// ## Examples
    ///
    ///     {title: The title of the song}
    ///     {chorus}
    ///     {start_of_verse}
    ///     {start_of_verse: Last Verse}
    ///
    /// - Note: This needs an extension for `ChoiceOf`
    static let directiveRegex = Regex {
        "{"
        Capture {
            ChoiceOf(directives)
        } transform: {
            Directive(rawValue: $0.lowercased()) ?? .none
        }
        Optionally {
            ":"
            TryCapture {
                OneOrMore {
                    CharacterClass(
                        .anyOf("}").inverted
                    )
                }
            } transform: {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        "}"
        Optionally {
            CharacterClass(
                .anyOf("{").inverted
            )
        }
    }

    /// The regex for a *normal*  line with optional`chords` and/or `lyrics`
    ///
    ///     /// ## Example
    ///
    ///     [A]I sing you a [G]song!!
    ///
    static let lineRegex = Regex {
        /// The chord
        Optionally {
            chordRegex
        }
        /// The lyric
        Optionally {
            Capture {
                OneOrMore {
                    CharacterClass(
                        .anyOf("[]").inverted
                    )
                }
            }
        }
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

    /// Regex for a chord
    static let chordRegex = Regex {
        Regex {
            "["
            Capture {
                OneOrMore {
                    CharacterClass(
                        .anyOf("[] ").inverted
                    )
                }
            }
            "]"
        }
    }
}
