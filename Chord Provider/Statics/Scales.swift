//
//  Scales.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

/// Static scale dictionaries
enum Scales {

    /// The note to value dictionary
    static var noteValueDict: [Chord.Root: Int] {
        [
            Chord.Root.c: 0,
            Chord.Root.cSharp: 1,
            Chord.Root.dFlat: 1,
            Chord.Root.d: 2,
            Chord.Root.dSharp: 3,
            Chord.Root.eFlat: 3,
            Chord.Root.e: 4,
            Chord.Root.f: 5,
            Chord.Root.fSharp: 6,
            Chord.Root.gFlat: 6,
            Chord.Root.g: 7,
            Chord.Root.gSharp: 8,
            Chord.Root.aFlat: 8,
            Chord.Root.a: 9,
            Chord.Root.aSharp: 10,
            Chord.Root.bFlat: 10,
            Chord.Root.b: 11
        ]
    }

    /// The value to note dictionary
    static var valueNoteDict: [Int: [Chord.Root]] {
        [
            0: [Chord.Root.c],
            1: [Chord.Root.dFlat, Chord.Root.cSharp],
            2: [Chord.Root.d],
            3: [Chord.Root.eFlat, Chord.Root.dSharp],
            4: [Chord.Root.e],
            5: [Chord.Root.f],
            6: [Chord.Root.fSharp, Chord.Root.gFlat],
            7: [Chord.Root.g],
            8: [Chord.Root.aFlat, Chord.Root.gSharp],
            9: [Chord.Root.a],
            10: [Chord.Root.bFlat, Chord.Root.aSharp],
            11: [Chord.Root.b]
        ]
    }

    /// The sharped scale dictionary
    static var sharpedScale: [Int: Chord.Root] {
        [
            0: Chord.Root.c,
            1: Chord.Root.cSharp,
            2: Chord.Root.d,
            3: Chord.Root.dSharp,
            4: Chord.Root.e,
            5: Chord.Root.f,
            6: Chord.Root.fSharp,
            7: Chord.Root.g,
            8: Chord.Root.gSharp,
            9: Chord.Root.a,
            10: Chord.Root.aSharp,
            11: Chord.Root.b
        ]
    }

    /// The flatted scale dictionary
    static var flattedScale: [Int: Chord.Root] {
        [
            0: Chord.Root.c,
            1: Chord.Root.dFlat,
            2: Chord.Root.d,
            3: Chord.Root.eFlat,
            4: Chord.Root.e,
            5: Chord.Root.f,
            6: Chord.Root.gFlat,
            7: Chord.Root.g,
            8: Chord.Root.aFlat,
            9: Chord.Root.a,
            10: Chord.Root.bFlat,
            11: Chord.Root.b
        ]
    }

    /// The scale to value dictionary
    static var scaleValueDict: [Chord.Root: [Int: Chord.Root]] {
        [
            Chord.Root.aFlat: flattedScale,
            Chord.Root.a: sharpedScale,
            Chord.Root.aSharp: sharpedScale,
            Chord.Root.bFlat: flattedScale,
            Chord.Root.b: sharpedScale,
            Chord.Root.c: flattedScale,
            Chord.Root.cSharp: sharpedScale,
            Chord.Root.dFlat: flattedScale,
            Chord.Root.d: sharpedScale,
            Chord.Root.dSharp: sharpedScale,
            Chord.Root.eFlat: flattedScale,
            Chord.Root.e: sharpedScale,
            Chord.Root.f: flattedScale,
            Chord.Root.fSharp: sharpedScale,
            Chord.Root.gFlat: flattedScale,
            Chord.Root.g: sharpedScale,
            Chord.Root.gSharp: sharpedScale
        ]
    }
}
