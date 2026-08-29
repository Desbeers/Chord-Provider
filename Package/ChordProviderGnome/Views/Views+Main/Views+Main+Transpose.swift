//
//  Views+Main+Transpose.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension Views.Main {

    /// The `View` for transposing a song
    struct Transpose: View {

        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            VStack {
                Text("Transpose song")
                    .heading()
                    .padding()
                HStack {
                    CountButton(
                        appState: $appState.onSet { _ in appState.editor.command = .updateSong },
                        icon: .goPrevious
                    ) { appState in
                        appState.editor.coreSettings.transpose = max(appState.editor.coreSettings.transpose - 1, -11)
                    }
                    Text("\(appState.editor.song.transposing) semitones")
                        .frame(minWidth: 150)
                    CountButton(
                        appState: $appState.onSet { _ in appState.editor.command = .updateSong },
                        icon: .goNext
                    ) { appState in
                        appState.editor.coreSettings.transpose = min(appState.editor.coreSettings.transpose + 1, 11)
                    }
                }
                .halign(.center)
                .padding()
                if appState.editor.song.metadata.transpose != 0 {
                    Text("The song is \(appState.editor.song.metadata.transpose) semitones transposed in the source")
                        .caption()
                }
                Button("Close") {
                    appState.scene.showTransposeDialog = false
                }
                .padding()
                .halign(.center)
                .pill()
                .suggested()
            }
            .valign(.center)
            .padding()
        }

        /// A `View` for a counter button
        private struct CountButton: View {

            /// The state of the application
            @Binding var appState: AppState
            /// The system icon for the button
            var icon: Icon.DefaultIcon
            /// The button tion
            var action: (inout AppState) -> Void
            /// The body of the `View`
            var view: Body {
                Button(icon: .default(icon: icon)) {
                    action(&appState)
                }
                .circular()
            }
        }
    }
}
