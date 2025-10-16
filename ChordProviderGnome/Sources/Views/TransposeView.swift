//
//  TransposeView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

/// The `View` for transposing a song
struct TransposeView: View {
    @Binding var appState: AppState
    var view: Body {
        VStack {
            Text("Transpose song")
                .heading()
                .padding()
            HStack {
                CountButton(settings: $appState.settings, icon: .goPrevious) {
                    $0.core.transpose = max($0.core.transpose - 1, -11)
                }
                Text("\(appState.settings.core.transpose) semitones")
                    .frame(minWidth: 150)
                CountButton(settings: $appState.settings, icon: .goNext) {
                    $0.core.transpose = min($0.core.transpose + 1, 11)
                }
            }
            .halign(.center)
            .padding()
            Button("Close") {
                appState.scene.isTransposed = appState.settings.core.transpose != 0
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

    private struct CountButton: View {
        @Binding var settings: AppSettings
        var icon: Icon.DefaultIcon
        var action: (inout AppSettings) -> Void

        var view: Body {
            Button(icon: .default(icon: icon)) {
                action(&settings)
            }
            .circular()
        }
    }
}
