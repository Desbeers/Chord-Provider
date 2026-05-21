//
//  Utils+MidiPlayer+chord.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension Utils.MidiPlayer {

    /// Play a chord definition
    /// - Parameters:
    ///   - chord: The chord definition
    ///   - preset: The MIDI preset
    ///   - strum: The kind of strum
    func playChord(_ chord: ChordDefinition, strum: Chord.Strum?) async {
        var components = chord.components
        if let strum, Chord.Strum.upStrums.contains(strum) {
            components.reverse()
        }
        let playbackNotes = chord.components.compactMap { component in
            if let midi = component.midi {
                return PlaybackNote(string: component.id, note: midi, articulation: .normal)
            }
            return nil
        }
        /// Reset all channels
        resetChannels()
        /// Play the chord
        await playNotes(playbackNotes, strum: strum)
    }
}