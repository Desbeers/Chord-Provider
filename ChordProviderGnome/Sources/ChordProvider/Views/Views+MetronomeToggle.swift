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
        /// Init the `View`
        /// - Parameter appState: The application state
        init(appState: Binding<AppState>) {
            let metadata = appState.editor.song.metadata.wrappedValue
            self.tempo = metadata.tempo
            self._appState = appState
            Task {
                if let tempo = metadata.tempo, let bpm = Int(tempo) {
                    await Utils.MidiPlayer.shared.setMetronomeBPM(bpm)
                    await Utils.MidiPlayer.shared.setMetronomeMeter(metadata.time ?? "4/4")
                } else {
                    await Utils.MidiPlayer.shared.stopMetronome()
                }
            }
        }
        /// The tempo of the metronome
        let tempo: String?
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            Box {
                if let tempo {
                    HStack {
                        Widgets.BundleImage(icon: .tempo)
                            .pixelSize(16)
                            .valign(.baselineCenter)
                            .style(.svgIcon)
                        Toggle(tempo, isOn: $appState.scene.playMetronome.onSet { value in
                            switch value {
                            case true:
                                Task {
                                    await Utils.MidiPlayer.shared.startMetronome()
                                }
                            case false:
                                Task {
                                    await Utils.MidiPlayer.shared.stopMetronome()
                                }
                            }
                        })
                        .style(.pageHeaderToggle)
                        .flat()
                        .padding(1, .top)
                    }
                }
            }
            .valign(.center)
            .onUpdate {
                if tempo == nil && appState.scene.playMetronome {
                    /// Set the correct state of the button
                    appState.scene.playMetronome = false
                }
            }
        }
    }
}
