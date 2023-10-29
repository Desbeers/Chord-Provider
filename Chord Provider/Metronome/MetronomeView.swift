//
//  MetronomeView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

struct MetronomeView: View {
    /// The time signature
    let time: String
    /// The bpm
    let bpm: Float
    /// The metronome model
    @StateObject var metronome = Metronome()
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
                            .rotation3DEffect(
                                .degrees(metronome.flip ? 180 : 0),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                    }
                )
            }
        )
        .buttonStyle(.bordered)
        .labelStyle(.titleAndIcon)
        .task(id: bpm) {
            metronome.bpm = bpm
        }
        .task(id: time) {
            metronome.time = time
        }
    }
}
