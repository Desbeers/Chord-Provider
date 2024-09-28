//
//  ChordDisplayOptions+buttons.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordDisplayOptions {

    // MARK: Play Button

    /// SwiftUI `Button` to play the chord with MIDI
    public struct PlayButton: View {
        /// Public init
        public init(chord: ChordDefinition, instrument: Midi.Instrument) {
            self.chord = chord
            self.instrument = instrument
        }
        /// The chord to play
        let chord: ChordDefinition
        /// The instrument to use
        let instrument: Midi.Instrument
        /// The body of the `View`
        public var body: some View {
            Button(action: {
                chord.play(instrument: instrument)
            }, label: {
                Label("Play", systemImage: "play.fill")
            })
            .disabled(chord.frets.isEmpty)
        }
    }
}
