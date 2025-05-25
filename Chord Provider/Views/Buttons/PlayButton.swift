//
//  PlayChordButton.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 24/05/2025.
//

import SwiftUI

/// SwiftUI `Button` to play the chord with MIDI
struct PlayChordButton: View {
    /// The chord to play
    let chord: ChordDefinition
    /// The ``Midi/Instrument`` to use
    let instrument: Midi.Instrument
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
