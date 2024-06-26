//
//  MetronomeView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the metronome
@MainActor
struct MetronomeView: View {
    /// The time signature
    let time: String
    /// The bpm
    let bpm: Float
    /// The metronome model
    @State var metronome = Metronome()
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
