//
//  RegexDefinitions.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation
import RegexBuilder

/// Regex definitions to parse a chord
enum RegexDefinitions {

    // MARK: Regex to parse a chord name

    /// The regex for a `chord` string
    ///
    /// It will parse the chord to find the `root` and optional `quality`
    ///
    ///     /// ## Examples
    ///
    ///     Am -> root: Am, quality: m
    ///     Dsus4 -> root: D, quality: sus4
    ///
    nonisolated(unsafe) static let chordName = Regex {
        /// The root
        chordRoot
        /// The optional quality
        Optionally {
            Capture {
                OneOrMore {
                    CharacterClass(
                        (.word),
                        (.digit),
                        .anyOf("#?")
                    )
                }
            } transform: { quality in
                /// Try to find the name of the quality
                for name in Chord.Quality.allCases where name.name.contains(String(quality)) {
                    return name
                }
                /// The quality is unknown
                return Chord.Quality.unknown
            }
        }
        Optionally {
            "/"
            chordRoot
        }
    }

    // MARK: Regex to parse a define

    /// The regex for a chord definition
    nonisolated(unsafe) static let chordDefine = Regex {
        /// Capture the name
        Capture {
            OneOrMore {
                CharacterClass(
                    .anyOf("#b/+?"),
                    (.word),
                    (.digit)
                )
            }
        } transform: { name in
            String(name)
        }
        /// Capture the base-fret
        Optionally {
            " base-fret "
            Capture {
                OneOrMore(.digit)
            } transform: { baseFret in
                Int(baseFret) ?? 0
            }
        }
        /// Capture the frets
        Optionally {
            " frets "
            Capture {
                OneOrMore {
                    CharacterClass(
                        .anyOf("x"),
                        (.digit),
                        (.whitespace)
                    )
                }
            } transform: { frets in
                String(frets).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        /// Capture the fingers
        Optionally {
            "fingers "
            Capture {
                OneOrMore {
                    CharacterClass(
                        (.digit),
                        (.whitespace)
                    )
                }
            } transform: { fingers in
                return String(fingers).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }

    // MARK: Regex to parse the root of a chord

    /// The regex to parse the root of a chord
    nonisolated(unsafe) static let chordRoot = Regex {
        Capture {
            OneOrMore {
                CharacterClass(
                    .anyOf("CDEFGABb#")
                )
            }
        } transform: { root in
            Chord.Root(rawValue: String(root)) ?? Chord.Root.none
        }
    }

    /// The regex for a `directive` with an optional `label`
    ///
    ///     /// ## Examples
    ///
    ///     {title: The title of the song}
    ///     {chorus}
    ///     {start_of_verse}
    ///     {start_of_verse: Last Verse}
    ///
    nonisolated(unsafe) static let directive = Regex {
        "{"
        Capture {
            OneOrMore(.word)
        }
        Optionally {
            OneOrMore {
                CharacterClass(
                    .anyOf(": ")
                )
            }
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

    nonisolated(unsafe) static let formattingAttributes = Regex {
        Capture {
            OneOrMore(.word)
        }
        "="
        Capture {
            OneOrMore {
                CharacterClass(
                    .word,
                    .anyOf("\"")
                )
            }
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
    nonisolated(unsafe) static let line = Regex {
        /// The chord
        Optionally {
            chord
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

    /// Regex for a chord
    nonisolated(unsafe) static let chord = Regex {
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
