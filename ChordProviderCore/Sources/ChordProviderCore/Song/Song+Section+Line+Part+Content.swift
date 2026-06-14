//
//  Song+Section+Line+Part+Content.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Song.Section.Line.Part {

    /// All possible content types for a `Part`
    ///
    /// The cases fall into three categories:
    /// - Grid content (e.g. `chord`, `barLine`, `strumPattern`)
    /// - Lyric content (`lyric`)
    /// - Plain or auxiliary text (`text`, `margin`)
    ///
    /// Note:
    /// - `chord`, `anyChord`, and `textChord` are used in grid contexts
    /// - `lyric` represents aligned text with an optional chord slot
    public enum Content: Codable, Sendable, Equatable {
        /// A lyric part that can consist of a text and/or a chord
        case lyric(content: Lyric)
        /// A chord in a grid context
        /// - Note: timed, with beat and strum information
        case chord(definition: ChordDefinition, textPart: Song.TextPart, beatItems: Int)
        /// Any chord in a grid content, written in the source as "/"
        /// - Note: timed, with beat and strum information
        case anyChord(textPart: Song.TextPart, beatItems: Int, strum: Chord.Strum)
        /// A placeholder chord with user-defined text
        /// - Note: Just text that should be rendered in a chord slot
        case textChord(textPart: Song.TextPart)
        /// Strum symbol
        case strum(symbol: Chord.Strum)
        /// Bar line symbol
        case barLine(symbol: ChordPro.Grid.BarLineSymbol)
        /// Strum pattern symbol
        case strumPattern(symbol: ChordPro.Grid.StrumPattern)
        /// Repeating symbol
        case repeating(symbol: ChordPro.Grid.RepeatingSymbol)
        /// Just plain text
        case text(textPart: Song.TextPart)
        /// Text in the margin of a grid
        case margin(textPart: Song.TextPart)

        // MARK: Calculated stuff

        // MARK: Check for content

        /// Bool if the content has a playable chord in a grid
        public var hasPlayableChord: Bool {
            switch self {
            case .chord, .anyChord:
                true
            default:
                false
            }
        }
        /// Bool if the content has a strum pattern
        public var hasStrumPattern: Bool {
            if case .strumPattern = self { true } else { false }
        }
        /// Bool if the content has a strum
        public var hasStrum: Bool {
            if case .strum = self { true } else { false }
        }
        /// Bool if the content has a bar line
        public var hasBarLine: Bool {
            if case .barLine = self { true } else { false }
        }
        /// Bool if a lyric part has a chord
        public var lyricHasChord: Bool {
            if case .lyric(let content) = self,
            content.chordSlot != .empty { true } else { false }
        }
        /// Bool if a lyric part has text
        public var lyricHasText: Bool {
            if case .lyric(let content) = self,
            !content.display.trimmingCharacters(in: .whitespaces).isEmpty { true } else { false }
        }
        /// Bool if the content is in the margin of a grid
        public var isInMargin: Bool {
            if case .margin = self { true } else { false }
        }

        // MARK: Get content

        /// Get a chord
        public var getChord: (definition: ChordDefinition, textPart: Song.TextPart, beatItems: Int)? {
            if case let .chord(definition, textPart, beatItems) = self {
                return (definition, textPart, beatItems)
            }
             if case let .lyric(lyric) = self {
                switch lyric.chordSlot {
                case let .chord(definition, textPart):
                    return (definition, textPart, 1)
                default:
                    return nil
                }
             }
            return nil
        }
        /// Get a strum symbol
        public var getStrum: Chord.Strum? {
            if case let .strum(symbol) = self { return symbol }
            return nil
        }
        /// Get a strum pattern symbol
        public var getStrumPattern: ChordPro.Grid.StrumPattern? {
            if case let .strumPattern(symbol) = self { return symbol }
            return nil
        }
        /// Get a bar line symbol
        public var getBarLine: ChordPro.Grid.BarLineSymbol? {
            if case let .barLine(symbol) = self { return symbol }
            return nil
        }
        /// Get a repeating symbol
        public var getRepeating: ChordPro.Grid.RepeatingSymbol? {
            if case let .repeating(symbol) = self { return symbol }
            return nil
        }
    }
}

extension Song.Section.Line.Part.Content {

    /// A lyric part that may contain text, something in the chord slot, or both
    /// - Note: The chord slot may contain a real chord, text, or be empty
    public struct Lyric: Equatable, Codable, Sendable {
        /// The text parts of the lyric, it can be empty
        public var textParts: [Song.TextPart] = []
        /// The chord slot of the lyric
        public var chordSlot: ChordSlot = .empty
        /// Display all the text with its optional prefic and suffix
        public var display: String {
            textParts.map(\.display).joined()
        }
    }

    /// The content of a chord slot
    /// - Note: `ChordSlot` is used to define what appears *above* a lyric.
    public enum ChordSlot: Equatable, Codable, Sendable {
        /// A *real* chord
        case chord(definition: ChordDefinition, textPart: Song.TextPart)
        /// Text in a chord slot
        case text(textPart: Song.TextPart)
        /// No content in the chord slot
        /// - Note: Used to preserve layout when there is only lyric text
        case empty
    }
}
