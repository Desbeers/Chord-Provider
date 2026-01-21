//
//  ChordPro+RegexDefinitions.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation
import RegexBuilder

extension ChordPro {

    /// Regex primitives used by the ChordPro parsing pipeline
    ///
    /// These regexes are intentionally scoped and rely on higher-level invariants enforced by the parser stages
    enum RegexDefinitions {

        // MARK: Regex to parse a chord string

        /// The regex to parse a `chord` string
        ///
        /// It will parse the chord to find the `root` and optional `quality` and `bass`
        ///
        ///     ## Examples
        ///
        ///     Am -> root: Am, quality: m
        ///     Dsus4 -> root: D, quality: sus4
        ///
        nonisolated(unsafe) static let chordString = Regex {
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

        // MARK: The regex to parse a **ChordPro** chord definition

        /// The regex to parse a **ChordPro** chord definition
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
                OneOrMore {
                    CharacterClass(
                        .word,
                        .anyOf("-")
                    )
                }
            }
            Optionally {
                OneOrMore {
                    CharacterClass(
                        .anyOf(": -")
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

        /// The regex for formatting attributes
        nonisolated(unsafe) static let formattingAttributes = Regex {
            Capture {
                OneOrMore(.word)
            }
            "="
            Capture {
                Optionally {
                    "\""
                }
                OneOrMore {
                    CharacterClass(
                        .anyOf("\"").inverted
                    )
                }
                Optionally {
                    "\""
                }
            } transform: {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        /// The regex for parsing a song line into parts
        nonisolated(unsafe) static let lineParts = Regex {
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

        /// The regex for a chord
        nonisolated(unsafe) static let chord = Regex {
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

        /// The regex for spitting a grid string into parts, separated by `space`, markup block or plain text
        nonisolated(unsafe) static let gridSeparator = Regex {
            Capture {
                ChoiceOf {
                    markupBlock
                    Capture {
                        OneOrMore {
                            CharacterClass(
                                .anyOf("<>"),
                                .whitespace
                            )
                            .inverted
                        }
                    }
                }
            }
        }
        /// The regex for spitting a song line string into parts, separated by markup block or plain text, including spaces
        nonisolated(unsafe) static let lineSeparator = Regex {
            ChoiceOf {
                Capture(markupBlock)
                Capture(textOnly)
            }
        }

        /// The regex for optional nested markup around plain text
        nonisolated(unsafe) static let optionalMarkup = Regex {
            Optionally {
                Capture(openTags)
            }
            Capture(textOnly)
            Optionally {
                Capture(closeTags)
            }
        }

        // MARK: Building blocks

        nonisolated(unsafe) private static let openTags = Regex {
            OneOrMore {
                "<"
                OneOrMore(CharacterClass.anyOf(">").inverted)
                ">"
            }
        }

        nonisolated(unsafe) private static let closeTags = Regex {
            OneOrMore {
                "</"
                OneOrMore(CharacterClass.anyOf(">").inverted)
                ">"
            }
        }

        nonisolated(unsafe) private static let textOnly = Regex {
            OneOrMore {
                CharacterClass.anyOf("<>").inverted
            }
        }

        nonisolated(unsafe) private static let markupBlock = Regex {
            openTags
            textOnly
            closeTags
        }
    }
}
