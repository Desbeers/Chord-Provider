//
//  ChordPostions.swift
//  Chord Provider
//
//  Created by Sascha Müller zum Hagen on 18.10.22.
//

import Foundation
import SwiftyChords

extension ChordPosition {
    
    /// Create a ChordPosition element from a string whcih defines the Chord with a ChordPro layout.
    ///  For mor information about the layout, have a look at https://www.chordpro.org/chordpro/directives-define/
    /// - Parameter define: ChordPro string definition of the chord.
    init(from define: String) throws {
        // The base implementation of ChordPostion only implements a decoder.
        // Use a 'C major' as base to define th e new chord from.
        // The SwiftyChords.ChordPostion does not allow to use any custom chords, because the key, and suffix are enum types.
        var baseFret: Int = 1
        var frets: [Int] = [0, 0, 0, 0, 0, 0]
        var fingers: [Int] = [0, 0, 0, 0, 0, 0]
        var barres: [Int] = []

        // try to get the chord out of the string without the finger position.
        // swiftlint:disable:next operator_usage_whitespace
        let regexBase = /base-fret(?<baseFret>[\s1-9]+)frets(?<frets>[\soOxXN0-9]+)(?<last>.*)/
        if let resultBase = try? regexBase.wholeMatch(in: define) {
            
            if let conv = Int(String(resultBase.baseFret).trimmingCharacters(in: .whitespacesAndNewlines)) {
                baseFret = conv
            }
            
            var fretsString = String(resultBase.frets).trimmingCharacters(in: .whitespacesAndNewlines)
            if !fretsString.isEmpty {
                fretsString = fretsString.replacingOccurrences(of: "[xX]", with: "-1", options: .regularExpression, range: nil)
                fretsString = fretsString.replacingOccurrences(of: "[oON]", with: "0", options: .regularExpression, range: nil)
                
                var fretsArr = fretsString.components(separatedBy: .whitespacesAndNewlines)
                fretsArr = fretsArr.filter { !$0.isEmpty }
                frets = fretsArr.map { Int($0)! }
                
                // append elements to have at least 6. This is needed to prevent a system failure.
                while frets.count < 6 { frets.append(0) }
            }
            
            // now try to get the finger postions.
            // swiftlint:disable:next operator_usage_whitespace
            let regexFingers = /fingers(?<fingers>[\s\-xXN0-9]+)(?<last>.*)/
            if let resultFingers = try? regexFingers.wholeMatch(in: resultBase.last) {

                var fingersString = String(resultFingers.fingers).trimmingCharacters(in: .whitespacesAndNewlines)
                if !fingersString.isEmpty {
                    fingersString = fingersString.replacingOccurrences(of: "[xXN-]", with: "0", options: .regularExpression, range: nil)
                    
                    var fingerArr = fingersString.components(separatedBy: .whitespacesAndNewlines)
                    fingerArr = fingerArr.filter { !$0.isEmpty }
                    fingers = fingerArr.map { Int($0)! }
                    
                    // append elements to have at least 6. This is needed to prevent a system failure.
                    while fingers.count < 6 { fingers.append(0) }

                    // set the barres but use not '0' as barres.
                    let mappedItems = fingers.map { ($0, 1) }
                    let counts = Dictionary(mappedItems, uniquingKeysWith: +)
                    for (key, value) in counts where value > 1 && key != 0 {
                        barres.append(key)
                    }
                }
            }
        }
        
        let data = """
    {
        "key": "C",
        "suffix": "major",
        "midi": [48, 52, 55, 60, 64],
        "baseFret": \(baseFret),
        "frets": \(frets),
        "fingers": \(fingers),
        "barres": \(barres)
    }
"""
        let decoder = JSONDecoder()
        self = try decoder.decode(ChordPosition.self, from: data.data(using: .utf8)!)
    }
}
