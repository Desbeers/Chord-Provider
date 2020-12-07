//
//  ChordsView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 06/12/2020.
//

import Foundation


func processChord(chord: String) -> [ChordPosition] {
    
    let chordRegex = try! NSRegularExpression(pattern: "([CDEFGAB#]+)(.*)")

    var key = ""
    var suffix = ""
    if let match = chordRegex.firstMatch(in: chord, options: [], range: NSRange(location: 0, length: chord.utf16.count)) {
        if let keyRange = Range(match.range(at: 1), in: chord) {
            key = chord[keyRange].trimmingCharacters(in: .newlines)
        }

        if let valueRange = Range(match.range(at: 2), in: chord) {
            switch chord[valueRange] {
                case "":
                    suffix = "major"
                case "m":
                    suffix = "minor"
                case "b":
                    suffix = "flat"
                default:
                    suffix = String(chord[valueRange])
            }
        }
    }
    return GetChord(key: key, suffix: suffix)
}

public struct ChordPosition: Codable {
    let frets: [Int]
    let fingers: [Int]
    let baseFret: Int
    let barres: [Int]
    var capo: Bool?
    let midi: [Int]
    let key: String
    let suffix: String
}

public struct GuitarChords {
    
    public static var all: [ChordPosition] {
        guard let data = ChordsData.data else {
            print("there is no chord data")
            return []
        }
        do {
            let allChords = try JSONDecoder().decode([ChordPosition].self, from: data)
            return allChords
        } catch {
            print(error)
        }
        return []
    }
}

func GetChord(key: String, suffix: String) -> [ChordPosition] {

    let match = GuitarChords.all.filter { $0.key == key }.filter { $0.suffix == suffix }
        if !match.isEmpty {
            return match
        }
        else {
            return[]
        }
}

func cleanChord(_ chord: ChordPosition) -> (frets: String, fingers: String) {
    var frets = ""
    for item in chord.frets {
        frets += (item == -1 ? "x" : String(item))
    }
    var fingers = ""
    for item in chord.fingers {
        fingers += (item == 0 ? "-" : String(item))
    }
    return (frets,fingers)
}
