//
//  TransposeView.swift
//  ChordProvider
//
//  Created by Nick Berendsen on 04/09/2025.
//

import Foundation
import ChordProviderCore
import Adwaita

struct TransposeView: View {
    @Binding var settings: AppSettings
    var view: Body {
        VStack {
            Text("Transpose song")
                .heading()
                .padding()
            HStack {
                CountButton(settings: $settings, icon: .goPrevious) {
                    $0.core.transpose = max($0.core.transpose - 1, -11)
                }
                Text("\(settings.core.transpose) semitones")
                    .frame(minWidth: 150)
                CountButton(settings: $settings, icon: .goNext) {
                    $0.core.transpose = min($0.core.transpose + 1, 11)
                }
            }
            .halign(.center)
            .padding()
            Button("Close") {
                settings.app.isTransposed = settings.core.transpose != 0
                settings.app.transposeDialog = false
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


