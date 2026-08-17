//
//  ChordDefinition+extensions.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import ChordProviderCore

extension ChordDefinition {

    /// The style of a Chord Definition ``/ChordProviderCore/Chord/Strum`` value
    var style: Markup.Class {
        if knownChord, let strum {
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
                .noStyle
            }
        } else {
            knownChord || kind == .anyChord ? .noStyle : .chordError
        }
    }
}
