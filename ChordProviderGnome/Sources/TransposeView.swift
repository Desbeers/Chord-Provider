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
    @Binding var settings: ChordProviderSettings
    var view: Body {
        VStack {
            HStack {
                CountButton(count: $settings.transpose, icon: .goPrevious) { $0 -= 1 }
                Text("\(settings.transpose) semitones")
                    .title2()
                    .frame(minWidth: 120)
                CountButton(count: $settings.transpose, icon: .goNext) { $0 += 1 }
            }
            .halign(.center)
        }
        .valign(.center)
        .padding()
    }

    private struct CountButton: View {
        @Binding var count: Int
        var icon: Icon.DefaultIcon
        var action: (inout Int) -> Void

        var view: Body {
            Button(icon: .default(icon: icon)) {
                action(&count)
            }
            .circular()
        }
    }

}


