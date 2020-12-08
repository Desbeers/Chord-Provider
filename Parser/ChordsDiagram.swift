//
//  ChordsView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 06/12/2020.
//

import Foundation


func processChord(chord: String, baseFret: String) -> [ChordPosition] {
    
    let base:Int = Int(baseFret.prefix(1)) ?? 1
    
    let chordRegex = try! NSRegularExpression(pattern: "([CDEFGABb#]+)(.*)")
    
    var key = ""
    var suffix = ""
    if let match = chordRegex.firstMatch(in: chord, options: [], range: NSRange(location: 0, length: chord.utf16.count)) {
        if let keyRange = Range(match.range(at: 1), in: chord) {
            key = chord[keyRange].trimmingCharacters(in: .newlines)
            /// Dirty, some chords in the database are only in the flat version....
            if key == "G#" {
                key = "Ab"
            }
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
    return GetChord(key: key, suffix: suffix, base: base)
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

func GetChord(key: String, suffix: String, base: Int) -> [ChordPosition] {

    let match = GuitarChords.all.filter { $0.key == key }.filter { $0.suffix == suffix }.filter { $0.baseFret == base }
        if !match.isEmpty {
            return match
        }
        else {
            print(key + " not found")
            return[]
        }
}

func cleanChord(_ chord: ChordPosition) -> (frets: String, fingers: String) {
    
    var frets = ""
    for item in chord.frets {
        frets += (item == -1 ? "x" : String(item + chord.baseFret - 1))
    }
    var fingers = ""
    for item in chord.fingers {
        fingers += (item == 0 ? "-" : String(item))
    }
    return (frets,fingers)
}
