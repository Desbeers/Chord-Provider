//
//  ChordPro+Regex.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
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

    /// The regex for a `define` directive
    ///
    ///     /// ## Example
    ///
    ///     {define: Bes base-fret 1 frets 1 1 3 3 3 1 fingers 1 1 2 3 4 1}
    ///
    ///     Key: Bes
    ///     Definition: base-fret 1 frets 1 1 3 3 3 1 fingers 1 1 2 3 4 1
    ///
    static let defineRegex = Regex {
        TryCapture {
            OneOrMore {
                CharacterClass(
                    .anyOf("#b"),
                    (.word),
                    (.digit)
                )
            }
        } transform: {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        TryCapture {
            OneOrMore(.any)
        } transform: {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
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
            Regex {
                "["
                Capture {
                    OneOrMore {
                        CharacterClass(
                            .anyOf("[]").inverted
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
