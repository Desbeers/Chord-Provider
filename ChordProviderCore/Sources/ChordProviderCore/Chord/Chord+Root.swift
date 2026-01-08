//
//  Chord+Root.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord {

    /// The root of a chord
    /// - Note: Changes to the raw value might break the databases
    public enum Root: String, CaseIterable, Codable, Comparable, Sendable, Identifiable, CustomStringConvertible {

        /// Identifiable protocol
        public var id: Self { self }

        /// CustomStringConvertible protocol
        public var description: String {
            self.rawValue
        }

        // swiftlint:disable identifier_name

        /// All
        case all = "All"
        /// C
        case c = "C"
        /// C sharp
        case cSharp = "C#"
        /// D
        case d = "D"
        /// D sharp
        case dSharp = "D#"
        /// D flat
        case dFlat = "Db"
        /// E
        case e = "E"
        /// E flat
        case eFlat = "Eb"
        /// F
        case f = "F"
        /// F sharp
        case fSharp = "F#"
        /// G
        case g = "G"
        /// G sharp
        case gSharp = "G#"
        /// G flat
        case gFlat = "Gb"
        /// A
        case a = "A"
        /// A sharp
        case aSharp = "A#"
        /// A flat
        case aFlat = "Ab"
        /// B
        case b = "B"
        /// B flat
        case bFlat = "Bb"
        /// None
        case none = "None"
        // swiftlint:enable identifier_name

        /// Implement Comparable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            allCases.firstIndex(of: lhs) ?? 0 < allCases.firstIndex(of: rhs) ?? 1
        }

        /// The display of Root
        public var display: String {
            switch self {
            case .all:     "All"
            case .c:        "C"
            case .cSharp:   "C♯"
            case .dFlat:    "D♭"
            case .d:        "D"
            case .dSharp:   "D♯"
            case .eFlat:    "E♭"
            case .e:        "E"
            case .f:        "F"
            case .fSharp:   "F♯"
            case .gFlat:    "G♭"
            case .g:        "G"
            case .gSharp:   "G♯"
            case .aFlat:    "A♭"
            case .a:        "A"
            case .aSharp:   "A♯"
            case .bFlat:    "B♭"
            case .b:        "B"
            case .none:     "None"
            }
        }

        // swiftlint:disable indentation_width

        /// The accidental of the root
        public var accidental: Accidental {
            switch self {
            case .all, .c, .d, .e, .f, .g, .a, .b, .none:
                    .natural
            case .cSharp, .dSharp, .fSharp, .gSharp, .aSharp:
                    .sharp
            case .dFlat, .eFlat, .gFlat, .aFlat, .bFlat:
                    .flat
            }
        }

        /// Natural and sharp notes
        public static var naturalAndSharp: [Chord.Root] {
            [.all, .c, .cSharp, .d, .dSharp, .e, .f, .fSharp, .g, .gSharp, .a, .aSharp, .b, .none]
        }

        /// Display natural and sharp notes a string
        public var naturalAndSharpDisplay: String {
            switch self {
            case .all:
                "All"
            case .c, .d, .e, .f, .g, .a, .b:
                self.rawValue
            case .cSharp:
                "C♯/D♭"
            case .dSharp:
                "D♯/E♭"
            case .fSharp:
                "F♯/G♭"
            case .gSharp:
                "G♯/F♭"
            case .aSharp:
                "A♯/B♭"
            case .dFlat, .eFlat, .gFlat, .aFlat, .bFlat:
                self.rawValue
            case .none:
                "None"
            }
        }

        /// Swap sharp for flat
        public var swapSharpForFlat: Root {
            switch self {
            case .cSharp:
                    .dFlat
            case .dSharp:
                    .eFlat
            case .fSharp:
                    .gFlat
            case .gSharp:
                    .aFlat
            case .aSharp:
                    .bFlat
            default:
                    .none
            }
        }

        // swiftlint:enable indentation_width
    }
}

extension Chord.Root {

    /// Transpose a note
    /// - Parameters:
    ///   - transpose: The transpose value
    ///   - scale: The scale of the note
    mutating func transpose(transpose: Int, scale: Chord.Root) {
        self = ChordUtils.transposeNote(note: self, transpose: transpose, scale: scale)
    }
}

extension Chord.Root {

    /// Convert a ``Chord/Root`` Enum to a note value
    var value: Int {
        ChordUtils.noteToValue(note: self)
    }
}

extension Array where Element == Chord.Root {

    /// Convert an array of ``Chord/Root`` notes to a sorted array of note values
    var values: [Int] {
        self.map { ChordUtils.noteToValue(note: $0) }.sorted()
    }
}
