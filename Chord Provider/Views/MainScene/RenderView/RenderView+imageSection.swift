//
//  RenderView+imageSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    // MARK: Image

    /// SwiftUI `View` for an image
    func imageSection(section: Song.Section) -> some View {
        var arguments = section.arguments
        if arguments?[.align] == nil {
            /// Set the default
            arguments?[.align] = "center"
        }
        return VStack {
            ImageView(
                fileURL: song.metadata.fileURL,
                arguments: arguments,
                scale: song.settings.scale,
                maxWidth: song.settings.maxWidth
            )
        }
        .frame(maxWidth: song.settings.maxWidth, alignment: getAlign(arguments))
        .wrapSongSection(
            label: section.label,
            settings: song.settings
        )
    }
}
