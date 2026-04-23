//
//  ChordDefinition+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import ChordProviderCore

extension ChordDefinition {

    /// Make a String with all the notes in a chord
    public var notesLabel: String {
        if let elements = self.noteCombinations.first {
            let notes = elements.map { $0.required ? "<b>\($0.note.display)</b>" : $0.note.display }
            return "<b>\(self.display)</b> contains \(notes.joined(separator: ", "))"
        }
        /// This should not happen
        return ""
    }

    /// Tooltip for the chord
    public var toolTip: String {
        self.knownChord ? "" : self.kind.description
    }

    /// All notes for a chord, required and optional
    public var notes: [String] {
        if let elements = self.noteCombinations.first {
            return elements.map(\.note.display)
        }
        /// This should not hapen
        return []
    }

    /// Bool if a finger position is correct
    public func correctFinger(string: Int) -> Bool {
        if let finger = fingers[safe: string], let fret = frets[safe: string] {
            return finger == 0 && (fret == -1 || fret == 0 ) ? true : finger > 0 && fret > 0 ? true : false
        }
        return true
    }

    var style: Markup.Class {
        if knownChord, let strum = self.strum {
            switch strum {
            case .downAccent, .upAccent:
            .strokeAccent
            case .downArpeggio, .upArpeggio:
            .strokeArpeggio
            case .downArpeggioAccent, .upArpeggioAccent:
            .strokeArpeggioAccent
            case .downMuted, .upMuted:
            .strokeMuted
            case .downMutedAccent, .upMutedAccent:
            .strokeMutedAccent
            case .downStaccato, .upStaccato:
            .strokeStaccato
            case .downStaccatoAccent, .upStaccatoAccent:
            .strokeStaccatoAccent
            case .noStrum:
            .strokeNone
            default:
            .none
            }
        } else {
           knownChord ? .none : .chordError
        }
    }
}
