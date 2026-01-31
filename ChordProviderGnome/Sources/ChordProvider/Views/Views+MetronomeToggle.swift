//
//  Views+MetronomeToggle.swift
//  ChordProvider
//
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// A `View` with a metronome button
    struct MetronomeToggle: View {
        init(metadata: Song.Metadata) {
            self.tempo = metadata.tempo
            Task {
                if let tempo = metadata.tempo, let bpm = Int(tempo) {
                    await Utils.MidiEngine.shared.setMetronomeBPM(bpm)
                    await Utils.MidiEngine.shared.setMetronomeMeter(metadata.time ?? "6/8")
                } else {
                    await Utils.MidiEngine.shared.stopMetronome()
                }
            }
        }
        let tempo: String?
        @State private var playMetronome: Bool = false
        var view: Body {
            if let tempo {
                HStack{
                    Widgets.BundleImage(name: "tempo")
                        .pixelSize(16)
                        .valign(.baselineCenter)
                        .style(.svgIcon)
                    Toggle(tempo, isOn: $playMetronome.onSet { value in
                        if let bpm = Int(tempo) {
                            switch value {
                            case true:
                                Task {
                                    await Utils.MidiEngine.shared.startMetronome(bpm: bpm)
                                }
                            case false:
                                Task {
                                    await Utils.MidiEngine.shared.stopMetronome()
                                }
                            }
                        }
                    })
                    .style(.metronomeButton)
                    .flat()
                }
            }
        }
    }
}
