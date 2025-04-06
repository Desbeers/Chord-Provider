//
//  RenderView+ProminentLabel.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 29/03/2025.
//

import SwiftUI

extension RenderView {

    /// SwiftUI `View` for a prominent label
    struct ProminentLabel: View {
        /// The ``Song``
        let song: Song
        /// The label
        let label: String
        /// The optional icon
        var icon: String?
        /// The font
        let font: Font
        /// The body of the `View`
        var body: some View {
            VStack {
                if let icon {
                    Label(
                        title: {
                            /// Init the text like this to enable markdown formatting
                            Text(.init(label))
                        },
                        icon: {
                            Image(systemName: icon)
                                .foregroundStyle(.primary, .primary)
                        }
                    )
                } else {
                    Text(.init(label))
                }
            }
            .font(font)
            .padding(song.scale * 6)
            .background(.secondary, in: RoundedRectangle(cornerRadius: 6))
        }
    }
}
