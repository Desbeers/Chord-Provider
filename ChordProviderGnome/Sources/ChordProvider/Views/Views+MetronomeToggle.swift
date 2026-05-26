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
import ChordProviderMIDI

extension Views {

    /// A `View` with a metronome button
    struct MetronomeToggle: View {
        /// Init the `View`
        /// - Parameter appState: The application state
        init(appState: Binding<AppState>) {
            let metadata = appState.editor.song.metadata.wrappedValue
            let tempo = metadata.tempo
            self._appState = appState
            Task {
                if tempo != nil {
                    await ChordProviderMIDI.shared.setSongTempo(tempo)
                    await ChordProviderMIDI.shared.setMetronomeTimeSignature(metadata.time ?? "4/4")
                } else {
                    await ChordProviderMIDI.shared.stopMetronome()
                }
            }
        }
        /// The tempo of the metronome
        var tempo: Int? {
            ChordProviderMIDI.shared.snapshot.tempo
        }
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
                        Toggle(String(tempo), isOn: $appState.scene.playMetronome.onSet { value in
                            switch value {
                            case true:
                                Task {
                                    await ChordProviderMIDI.shared.playMetronome()
                                }
                            case false:
                                Task {
                                    await ChordProviderMIDI.shared.stopMetronome()
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
