//
//  MetronomeButton.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the metronome button
struct MetronomeButton: View {
    /// The time signature
    let time: String
    /// The bpm
    let bpm: Float
    /// The observable state of the metronome
    @State var metronome = MetronomeModel()
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                metronome.enabled.toggle()
            },
            label: {
                Label(
                    title: {
                        Text(bpm.formatted())
                    },
                    icon: {
                        Image(systemName: metronome.enabled ? "metronome.fill" : "metronome")
                            .scaleEffect(x: metronome.flip ? -1 : 1, y: 1)
                    }
                )
            }
        )
        .labelStyle(.titleAndIcon)
        .task(id: bpm) {
            metronome.bpm = bpm
        }
        .task(id: time) {
            metronome.time = time
        }
    }
}
