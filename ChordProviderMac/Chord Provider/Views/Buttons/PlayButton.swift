//
//  PlayChordButton.swift
//  Chord Provider
//
//  © 2026 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `Button` to play the chord with MIDI
struct PlayChordButton: View {
    /// The chord to play
    let chord: ChordDefinition
    /// The `MidiUtils/Preset` to use
    let instrument: MidiUtils.Preset
    /// The body of the `View`
    var body: some View {
        Button(action: {
            chord.play(instrument: instrument)
        }, label: {
            Label("Play", systemImage: "play.fill")
        })
        .disabled(chord.frets.isEmpty)
    }
}
