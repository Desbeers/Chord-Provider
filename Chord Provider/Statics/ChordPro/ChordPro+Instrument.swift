//
//  ChordPro+Instrument.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordPro {

    // MARK: Instrument
    struct Instrument: Codable {
        let instrument: Instrument
        let tuning: [String]
        let chords: [Chord]
        let pdf: PDF
    }
}

extension ChordPro.Instrument {

    // MARK: Chord
    struct Chord: Codable {
        let name: String
        let display: String?
        let base: Int?
        let frets: [Int]?
        let fingers: [Int]?
        let copy: String?
    }

    // MARK: Instrument
    struct Instrument: Codable {
        let description, type: String
    }

    // MARK: PDF
    struct PDF: Codable {
        let diagrams: Diagrams
    }

    // MARK: Diagrams
    struct Diagrams: Codable {
        let vcells: Int
    }
}
