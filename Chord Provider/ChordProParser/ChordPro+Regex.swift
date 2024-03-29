//
//  ChordPro+Regex.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import RegexBuilder

extension ChordPro {

    // MARK: Regex definitions

    /// The regex for a `directive` with an optional `label`
    ///
    ///     /// ## Examples
    ///
    ///     {title: The title of the song}
    ///     {chorus}
    ///     {start_of_verse}
    ///     {start_of_verse: Last Verse}
    ///
    static let directiveRegex = Regex {
        "{"
        TryCapture {
            OneOrMore {
                CharacterClass(
                    .anyOf(":").inverted
                )
            }
        } transform: {
            Directive(rawValue: $0.lowercased())
        }
        Optionally {
            ":"
            TryCapture {
                OneOrMore(.any)
            } transform: {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        "}"
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
}
