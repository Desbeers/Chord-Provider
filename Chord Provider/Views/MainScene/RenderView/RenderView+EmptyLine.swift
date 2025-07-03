//
//  RenderView+EmptyLine.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    /// Add an empty line to a section
    struct EmptyLine: View {
        /// The settings for the song
        let settings: AppSettings
        /// The body of the `View`
        var body: some View {
            Color.clear
                .frame(height: settings.style.fonts.text.size * settings.scale.magnifier)
        }
    }
}
