//
//  ChordProviderMIDI+playChord.swift
//  ChordProviderMIDI
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension ChordProviderMIDI {

    /// Play a chord definition
    /// - Parameters:
    ///   - chord: The chord definition
    ///   - strum: The kind of strum
    public func playChord(_ chord: ChordDefinition, strum: Chord.Strum?) async {
        var components = chord.components
        if let strum, Chord.Strum.upStrums.contains(strum) {
            components.reverse()
        }
        let playbackNotes = components.compactMap { component in
            if let midi = component.midi {
                return PlaybackNote(stringID: component.id, articulation: .normal(note: midi))
            }
            return nil
        }
        /// Reset all channels
        resetChannels()
        /// Play the chord
        await playNotes(playbackNotes, strum: strum)
    }
}