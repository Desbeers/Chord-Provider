//
//  Chord+Root.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Chord {

    /// The root of a chord
    /// - Note: Changes to the raw value might break the databases
    public enum Root: String, CaseIterable, Codable, Comparable, Sendable, Identifiable {

        /// Identifiable protocol
        public var id: String {
            self.rawValue
        }

        // swiftlint:disable identifier_name

        /// None
        case none = "None"
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
        // swiftlint:enable identifier_name

        /// Implement Comparable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            allCases.firstIndex(of: lhs) ?? 0 < allCases.firstIndex(of: rhs) ?? 1
        }

        /// Contains text for accessibility text-to-speech and symbolised versions.
        public var display: (accessible: String, symbol: String) {
            switch self {
            case .c:
                ("C", "C")
            case .cSharp:
                ("C sharp", "C♯")
            case .dFlat:
                ("D flat", "D♭")
            case .d:
                ("D", "D")
            case .dSharp:
                ("D sharp", "D♯")
            case .eFlat:
                ("E flat", "E♭")
            case .e:
                ("E", "E")
            case .f:
                ("F", "F")
            case .fSharp:
                ("F sharp", "F♯")
            case .gFlat:
                ("G flat", "G♭")
            case .g:
                ("G", "G")
            case .gSharp:
                ("G sharp", "G♯")
            case .aFlat:
                ("A flat", "A♭")
            case .a:
                ("A", "A")
            case .aSharp:
                ("A sharp", "A♯")
            case .bFlat:
                ("B flat", "B♭")
            case .b:
                ("B", "B")
            case .none:
                ("X", "X")
            }
        }

        /// The accidental of the root
        public var accidental: Accidental {
            switch self {
            case .c, .d, .e, .f, .g, .a, .b, .none:
                    .natural
            case .cSharp, .dSharp, .fSharp, .gSharp, .aSharp:
                    .sharp
            case .dFlat, .eFlat, .gFlat, .aFlat, .bFlat:
                    .flat
            }
        }

        /// The copy of a root
        public var copy: Root {
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
    }
}

public extension Chord.Root {

    /// Transpose a note
    /// - Parameters:
    ///   - transpose: The transpose value
    ///   - scale: The scale of the note
    mutating func transpose(transpose: Int, scale: Chord.Root) {
        self = Utils.transposeNote(note: self, transpose: transpose, scale: scale)
    }
}

extension String {

    /// Convert a `Root` string to a `Root` enum
    var rootEnumValue: Chord.Root? {
        Chord.Root(rawValue: self)
    }
}
