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
            HStack {
                CountButton(settings: $settings, icon: .goPrevious) {
                    $0.core.transpose = max($0.core.transpose - 1, -11)
                    $0.app.isTransposed = $0.core.transpose != 0
                }
                Text("\(settings.core.transpose) semitones")
                    .title2()
                    .frame(minWidth: 150)
                CountButton(settings: $settings, icon: .goNext) {
                    $0.core.transpose = min($0.core.transpose + 1, 11)
                    $0.app.isTransposed = $0.core.transpose != 0
                }
            }
            .halign(.center)
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


