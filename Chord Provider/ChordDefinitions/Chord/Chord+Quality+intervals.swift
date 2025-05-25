//
//  Chord+Quality+intervals.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

// 0:  R:     C  Perfect Unison
// 1:  m2:    C# Minor Second
// 2:  M2:    D  Major Second
// 3:  m3:    D# Augmented Second / Minor Third
// 4:  M3:    E  Major Third
// 5:  P4:    F  Perfect Fourth
// 6:  A4/d5: F# Augmented Fourth / Diminished Fifth
// 7:  P5:    G  Perfect Fifth
// 8:  A5/m6: G# Augmented Fifth / Minor Sixth
// 9:  M6:    A  Major Sixth
// 10: m7:    A# Minor Seventh
// 11: M7:    B  Major Seventh

import Foundation

extension Chord.Quality {

    /// The intervals of a ``Chord/Quality``
    var intervals: (intervals: [Chord.Interval], optional: [Chord.Interval]) {
        switch self {

            // MARK: - Triad

        case .major:
            /// C    E    G
            ([.P1, .M3, .P5], [])
        case .minor:
            /// C    Eb    G
            ([.P1, .m3, .P5], [])
        case .aug:
            /// C    E    G#
            ([.P1, .M3, .A5], [])
        case .dim:
            /// C    Eb    Gb
            ([.P1, .m3, .d5], [])

            // MARK: - Seventh

        case .seven:
            /// C E G (optional)   Bb
            ([.P1, .M3, .P5, .m7], [.P5])
        case .sevenSharpFive:
            /// C    E    G#    Bb
            ([.P1, .M3, .A5, .m7], [])
        case .sevenFlatFive:
            /// C    E    Gb    Bb
            ([.P1, .M3, .d5, .m7], [])
        case .sevenSharpNine:
            /// C    E    G (optional)    Bb    D#
            ([.P1, .M3, .P5, .m7, .A9], [.P5])
        case .sevenFlatNine:
            /// C    E    G (optional)    Bb    Db
            ([.P1, .M3, .P5, .m7, .d9], [.P5])
        case .minorSeven:
            /// C   Eb   G (optional)   Bb
            ([.P1, .m3, .P5, .m7], [.P5])
        case .majorSeven:
            /// C    E    G (optional)    B
            ([.P1, .M3, .P5, .M7], [.P5])
        case .augSeven:
            /// C    E    G#    Bb
            ([.P1, .M3, .A5, .m7], [])
        case .dimSeven:
            /// C    Eb    Gb    Bbb
            ([.P1, .m3, .d5, .d7], [])
        case .majorSevenSharpFive:
            /// C    E    G#    B
            ([.P1, .M3, .A5, .M7], [])
        case .majorSevenFlatFive:
            /// C    E    Gb    B
            ([.P1, .M3, .d5, .M7], [])
        case .minorMajorSeven:
            /// C    Eb    G (optional)    B
            ([.P1, .m3, .P5, .M7], [.P5])
        case .minorMajorSevenFlatFive:
            /// C    Eb    Gb    B
            /// 1    m3    b5    7
            ([.P1, .m3, .d5, .M7], [])
        case .minorSevenFlatFive:
            /// C    Eb    Gb    Bb
            ([.P1, .m3, .d5, .m7], [])

            // MARK: - Suspended

        case .susTwo:
            /// C    D    G
            ([.P1, .M2, .d6], [])
        case .susFour:
            /// C    F    G
            ([.P1, .P4, .d6], [])
        case .sevenSusTwo:
            /// C    D    G (optional)    Bb
            ([.P1, .M2, .P5, .m7], [.P5])
        case .sevenSusFour:
            /// C    F    G (optional)    Bb
            ([.P1, .P4, .P5, .m7], [.P5])

            // MARK: - Extended

            // MARK: Nine

        case .nine:
            /// C    E    G (optional)    Bb    D
            ([.P1, .M3, .P5, .m7, .M9], [.P5])
        case .majorNine:
            /// C    E    G (optional)    B    D
            ([.P1, .M3, .P5, .M7, .M9], [.P5])
        case .minorMajorNine:
            /// C    Eb    G (optional)    B    D
            ([.P1, .m3, .P5, .M7, .M9], [.P5])
        case .minorNine:
            /// C    Eb    G (optional)    Bb    D
            ([.P1, .m3, .P5, .m7, .M9], [.P5])
        case .nineFlatFive:
            /// C    E    Gb    Bb    D
            ([.P1, .M3, .d5, .m7, .M9], [])
        case .nineSharpEleven:
            /// C    E    G (optional)    Bb    D (o)    F#
            ([.P1, .M3, .P5, .m7, .M9, .d12], [.P5])

            // MARK: eleven

        case .eleven:
            /// C    E    G (optional)    Bb    D (optional)    F
            ([.P1, .M3, .P5, .m7, .M9, .P11], [.P5, .M9])
        case .majorEleven:
            /// C    E    G (optional)    B    D (optional)    F
            ([.P1, .M3, .P5, .M7, .M9, .P11], [.P5, .M9])
        case .minorEleven:
            /// C    Eb    G (optional)    Bb    D (optional)    F
            ([.P1, .m3, .P5, .m7, .M9, .P11], [.P5, .M9])
        case .minorMajorEleven:
            /// C    Eb    G (optional)    B    D (optional)    F
            ([.P1, .m3, .P5, .M7, .M9, .P11], [.P5, .M9])

            // MARK: Thirteen

        case .thirteen:
            /// C    E    G (optional)    Bb    D (optional)    F (optional)    A
            ([.P1, .M3, .P5, .m7, .M9, .P11, .M13], [.P5, .M9, .P11])
        case .majorThirteen:
            /// C    E    G (optional)    B    D (optional)    F (optional)    A
            ([.P1, .M3, .P5, .M7, .M9, .P11, .M13], [.P5, .M9, .P11])
        case .minorThirteen:
            /// C    Eb    G (optional)    Bb    D (optional)    F (optional)    A
            ([.P1, .m3, .P5, .m7, .M9, .P11, .M13], [.P5, .M9, .P11])

            // MARK: - Added

        case .five:
            /// C    G
            ([.P1, .P5], [])
        case .six:
            /// C    E    G (optional)    A
            ([.P1, .M3, .P5, .M6], [.P5])
        case .minorSix:
            /// C    Eb    G (optional)    A
            ([.P1, .m3, .P5, .M6], [.P5])
        case .sixNine:
            /// C    E    G (optional)    A    D
            ([.P1, .M3, .P5, .M6, .M9], [.P5])
        case .minorSixNine:
            /// C    Eb    G (optional)    A    D
            ([.P1, .m3, .P5, .M6, .M9], [.P5])
        case .addFour:
            /// C    E    F   G  (optional) 
            ([.P1, .M3, .P4, .P5], [.P5])
        case .addNine:
            /// C    E    G (optional)    D
            ([.P1, .M3, .P5, .M9], [.P5])
        case .addEleven:
            /// C    E    G (optional)    F
            ([.P1, .M3, .P5, .P11], [.P5])
        case .minorAddNine:
            /// C    Eb    G (optional)    D
            ([.P1, .m3, .P5, .M9], [.P5])

            // MARK: - Augmented

        case .augNine:
            /// C    E    G#    Bb    D
            ([.P1, .M3, .A5, .m7, .M9], [])

            // MARK: - Unknown

        case.unknown:
            ([], [])
        }
    }
}
