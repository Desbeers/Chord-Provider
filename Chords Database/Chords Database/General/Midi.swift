//
//  Midi.swift
//  Chords Database
//
//  Created by Nick Berendsen on 28/10/2022.
//

import Foundation
import SwiftyChords

struct MidiNote: Identifiable {
    var id = UUID()
    let note: Int
    let sting: String
}

enum MidiNotes: Int {
    // swiftlint:disable identifier_name
    case e
    case f
    case fSharp
    case g
    case gSharp
    case a
    case aSharp
    case b
    case c
    case cSharp
    case d
    case dSharp
    // swiftlint:enable identifier_name
}

extension MidiNotes {
    
    /// Base MIDI valies
    var value: Int {
        switch self {
        case .e:
            return 40
        case .f:
            return 41
        case .fSharp:
            return 42
        case .g:
            return 43
        case .gSharp:
            return 44
        case .a:
            return 45
        case .aSharp:
            return 46
        case .b:
            return 47
        case .c:
            return 48
        case .cSharp:
            return 49
        case .d:
            return 50
        case .dSharp:
            return 51
        }
    }
    
    var display: (accessible: String, symbol: String) {
        switch self {
        case .c:
            return ("C", "C")
        case .cSharp:
            return ("C sharp", "C♯")
        case .d:
            return ("D", "D")
        case .dSharp:
            return ("D sharp", "D♯")
        case .e:
            return ("E", "E")
        case .f:
            return ("F", "F")
        case .fSharp:
            return ("F sharp", "F♯")
        case .g:
            return ("G", "G")
        case .gSharp:
            return ("G sharp", "G♯")
        case .a:
            return ("A", "A")
        case .aSharp:
            return ("A sharp", "A♯")
        case .b:
            return ("B", "B")
        }
    }
}

extension MidiNotes {
    
// MARK: Fret positions to MIDI values
    
    static func values(values: Chord) -> [Int] {
        return calculateValues(frets: values.frets, baseFret: values.baseFret)
    }
    
    static func values(values: ChordPosition) -> [Int] {
        return calculateValues(frets: values.frets, baseFret: values.baseFret)
    }
    
    static private func calculateValues(frets: [Int], baseFret: Int) -> [Int] {
        var midiNotes: [Int] = []
        for string in Strings.allCases {
            var fret = frets[string.rawValue]
            /// Don't bother with ignored frets
            if fret != -1 {
                /// Add base fret and the offset
                fret += baseFret + string.offset
                /// Find the base midi value
                if let midiNote = MidiNotes(rawValue: (fret) % 12) {
                    let midi = midiNote.value + ((fret / 12) * 12)
                    midiNotes.append(midi)
                }
            }
            
        }
        return midiNotes
    }
    
    static func calculate(values: ChordPosition) -> [MidiNote] {
        var midiNotes: [MidiNote] = []
        for string in Strings.allCases {
            var fret = values.frets[string.rawValue]
            /// Don't bother with ignored frets
            if fret != -1 {
                /// Add base fret and the offset
                fret += values.baseFret + string.offset
                /// Find the base midi value
                if let midiNote = MidiNotes(rawValue: (fret) % 12) {
                    let midi = midiNote.value + ((fret / 12) * 12)
                    midiNotes.append(.init(note: (midi),
                                           sting: String(describing: midiNote)))
                }
            }

        }
        return midiNotes
    }
}

extension MidiNotes {
    
    // MARK: MIDI note to Key String
    
    static func keyString(note: Int) -> String {
        if let midiNote = MidiNotes(rawValue: ((note - 40) % 12)) {
            let number = (note - 40) / 12 + 2
            return midiNote.display.symbol + number.description
        }
        
        return "?"
    }
}
