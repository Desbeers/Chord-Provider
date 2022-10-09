//
//  Chord.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftyChords

extension Song {
    
    /// The chords of the ``Song``
    struct Chord: Identifiable {
        var id = UUID()
        var name: String
        var key: SwiftyChords.Chords.Key
        var suffix: SwiftyChords.Chords.Suffix
        var define: String
        var basefret: Int {
            return Int(define.prefix(1)) ?? 1
        }
        /// Display name for the chord
        var display: String {
            var text = key.display.symbol
            switch self.suffix {
            case .major:
                break
            default:
                text += suffix.display.symbolized
            }
            return text
        }
    }
}

extension SwiftyChords.Chords.Key {
    
    /// Cut/paste from 'Guitar Chords' because its a private var in the package
    var display: (accessible: String, symbol: String) {
        switch self {
        case .c:
            return ("C", "C")
        case .cSharp:
            return ("C sharp", "C♯")
        case .d:
            return ("D", "D")
        case .eFlat:
            return ("E flat", "E♭")
        case .e:
            return ("E", "E")
        case .f:
            return ("F", "F")
        case .fSharp:
            return ("F sharp", "F♯")
        case .g:
            return ("G", "G")
        case .aFlat:
            return ("A flat", "A♭")
        case .a:
            return ("A", "A")
        case .bFlat:
            return ("B flat", "B♭")
        case .b:
            return ("B", "B")
        }
    }
}

extension SwiftyChords.Chords.Suffix {
    
    /// Cut/paste from 'Guitar Chords' because its a private var in the package
    var display: (accessible: String, short: String, symbolized: String, altSymbol: String) {
        switch self {
        case .major:
            return (" major", "Maj", "M", "M")
        case .minor:
            return (" minor", "min", "m", "m")
        case .dim:
            return (" diminished", "dim", "dim", "dim")
        case .dimSeven:
            return (" dim seven", "dim7", "dim⁷", "°")
        case .susTwo:
            return (" suss two", "sus2", "sus²", "sus²")
        case .susFour:
            return (" suss four", "sus4", "sus⁴", "sus⁴")
        case .sevenSusFour:
            return (" seven sus four", "7sus4", "⁷sus⁴", "⁷sus⁴")
        case .altered:
            return (" alt", "alt", "alt", "alt")
        case .aug:
            return (" augmented", "aug", "aug", "⁺")
        case .six:
            return (" six", "6", "⁶", "⁶")
        case .sixNine:
            return (" six slash nine", "6/9", "⁶ᐟ⁹", "⁶ᐟ⁹")
        case .seven:
            return (" seven", "7", "⁷", "⁷")
        case .sevenFlatFive:
            return (" seven flat five", "7b5", "⁷♭⁵", "⁷♭⁵")
        case .augSeven:
            return (" org seven", "aug7", "aug⁷", "⁺⁷")
        case .nine:
            return (" nine", "9", "⁹", "⁹")
        case .nineFlatFive:
            return (" nine flat five", "9b5", "⁹♭⁵", "⁹♭⁵")
        case .augNine:
            return (" org nine", "aug9", "aug⁹", "⁺⁹")
        case .sevenFlatNine:
            return (" seven flat nine", "7b9", "⁷♭⁹", "⁷♭⁹")
        case .sevenSharpNine:
            return (" seven sharp nine", "7#9", "⁷♯⁹", "⁷♯⁹")
        case .eleven:
            return (" eleven", "11", "¹¹", "¹¹")
        case .nineSharpEleven:
            return (" nine sharp eleven", "9#11", "⁹♯¹¹", "⁹♯¹¹")
        case .thirteen:
            return (" thirteen", "13", "¹³", "¹³")
        case .majorSeven:
            return (" major seven", "Maj7", "Maj⁷", "M⁷")
        case .majorSevenFlatFive:
            return (" major seven flat five", "Maj7b5", "Maj⁷♭⁵", "M⁷♭⁵")
        case .majorSevenSharpFive:
            return (" major seven sharp five", "Maj7#5", "Maj⁷♯⁵", "M⁷♯⁵")
        case .majorNine:
            return (" major nine", "Maj9", "Maj⁹", "M⁹")
        case .majorEleven:
            return (" major eleven", "Maj11", "Maj¹¹", "M¹¹")
        case .majorThirteen:
            return (" major thirteen", "Maj13", "Maj¹³", "M¹³")
        case .minorSix:
            return (" minor six", "m6", "m⁶", "m⁶")
        case .minorSixNine:
            return (" minor six slash nine", "m6/9", "m⁶ᐟ⁹", "m⁶ᐟ⁹")
        case .minorSeven:
            return (" minor seven", "m7", "m⁷", "m⁷")
        case .minorSevenFlatFive:
            return (" minor seven flat five", "m7b5", "m⁷♭⁵", "ø⁷")
        case .minorNine:
            return (" minor nine", "m9", "m⁹", "m⁹")
        case .minorEleven:
            return (" minor eleven", "m11", "m¹¹", "m¹¹")
        case .minorMajorSeven:
            return (" minor major seven", "mMaj7", "mMaj⁷", "mᴹ⁷")
        case .minorMajorSeventFlatFive:
            return (" minor major seven flat five", "mMaj7b5", "mMaj⁷♭⁵", "mᴹ⁷♭⁵")
        case .minorMajorNine:
            return (" minor major nine", "mMaj9", "mMaj⁹", "mᴹ⁹")
        case .minorMajorEleven:
            return (" minor major eleven", "mMaj11", "mMaj¹¹", "mᴹ¹¹")
        case .addNine:
            return (" add nine", "add9", "add⁹", "ᵃᵈᵈ⁹")
        case .minorAddNine:
            return (" minor add nine", "madd9", "madd⁹", "mᵃᵈᵈ⁹")
        case .slashE:
            return (" slash E", "/E", "/E", "/E")
        case .slashF:
            return (" slash F", "/F", "/F", "/F")
        case .slashFSharp:
            return (" slash F sharp", "/F#", "/F♯", "/F♯")
        case .slashG:
            return (" slash G", "/G", "/G", "/G")
        case .slashGSharp:
            return (" slash G sharp", "/G#", "/G♯", "/G♯")
        case .slashA:
            return (" slash A", "/A", "/A", "/A")
        case .slashBFlat:
            return (" slash B flat", "/Bb", "/B♭", "/B♭")
        case .slashB:
            return (" slash B", "/B", "/B", "/B")
        case .slashC:
            return (" slash C", "/C", "/C", "/C")
        case .slashCSharp:
            return (" slash C sharp", "/C#", "/C♯", "/C♯")
        case .minorSlashB:
            return (" minor slash B", "m/B", "m/B", "m/B")
        case .minorSlashC:
            return (" minor slash C", "m/C", "m/C", "m/C")
        case .minorSlashCSharp:
            return (" minor slash C sharp", "m/C#", "m/C♯", "m/C♯")
        case .slashD:
            return (" slash D", "/D", "/D", "/D")
        case .minorSlashD:
            return (" minor slash D", "m/D", "m/D", "m/D")
        case .slashDSharp:
            return (" slash D sharp", "/D#", "/D♯", "/D♯")
        case .minorSlashDSharp:
            return (" minor slash D sharp", "m/D#", "m/D♯", "m/D♯")
        case .minorSlashE:
            return (" minor slash E", "m/E", "m/E", "m/E")
        case .minorSlashF:
            return (" minor slash F", "m/F", "m/F", "m/F")
        case .minorSlashFSharp:
            return (" minor slash F sharp", "m/F#", "m/F♯", "m/F♯")
        case .minorSlashG:
            return (" minor slash G", "m/G", "m/G", "m/G")
        case .minorSlashGSharp:
            return (" minor slash G sharp", "m/G#", "m/G♯", "m/G♯")
        }
    }
}
