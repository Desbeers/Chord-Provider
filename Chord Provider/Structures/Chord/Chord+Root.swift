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
    enum Root: String, CaseIterable, Codable, Comparable, Sendable, Identifiable {

        /// Identifiable protocol
        var id: String {
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
        static func < (lhs: Self, rhs: Self) -> Bool {
            allCases.firstIndex(of: lhs) ?? 0 < allCases.firstIndex(of: rhs) ?? 1
        }

        /// The display of Root
        var display: String {
            switch self {
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
            case .none:     "All"
            }
        }

        // swiftlint:disable indentation_width

        /// The accidental of the root
        var accidental: Accidental {
            switch self {
            case .c, .d, .e, .f, .g, .a, .b, .none:
                    .natural
            case .cSharp, .dSharp, .fSharp, .gSharp, .aSharp:
                    .sharp
            case .dFlat, .eFlat, .gFlat, .aFlat, .bFlat:
                    .flat
            }
        }

        /// Swap sharp and flat
        var swapSharpFlat: Root {
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
        self = Utils.transposeNote(note: self, transpose: transpose, scale: scale)
    }
}

extension String {

    /// Convert a `Root` string to a `Root` enum
    var rootEnumValue: Chord.Root? {
        Chord.Root(rawValue: self)
    }
}
