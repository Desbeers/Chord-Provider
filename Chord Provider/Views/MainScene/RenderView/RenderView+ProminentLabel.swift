//
//  RenderView+ProminentLabel.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    /// SwiftUI `View` for a prominent label
    struct ProminentLabel: View {
        /// The label
        let label: String
        /// The optional icon
        var sfIcon: String?
        /// The font
        let font: Font
        /// The application settings
        let settings: AppSettings
        /// The body of the `View`
        var body: some View {
            VStack {
                if let sfIcon {
                    Label(
                        title: {
                            /// Init the text like this to enable markdown formatting
                            Text(.init(label))
                        },
                        icon: {
                            Image(systemName: sfIcon)
                                .foregroundStyle(.primary, .primary)
                        }
                    )
                } else {
                    Text(.init(label))
                }
            }
            .font(font)
            .padding(.top, settings.scale * 6)
            .padding(.horizontal, settings.scale * 6)
            .padding(.bottom, settings.scale * 5)
            .background(.secondary, in: RoundedRectangle(cornerRadius: 6))
        }
    }
}
