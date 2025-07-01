//
//  RenderView+ImageSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    struct ImageSection: View {
        /// The section of the song
        let section: Song.Section
        /// The settings for the song
        let settings: AppSettings
        /// The arguments
        var arguments: ChordProParser.DirectiveArguments?
        /// The alignment of the image
        let alignment: Alignment
        /// Init the struct
        init(section: Song.Section, settings: AppSettings) {
            self.section = section
            self.settings = settings
            self.arguments = section.arguments
            if arguments?[.align] == nil {
                /// Set the default
                self.arguments?[.align] = "center"
            }
            self.alignment = getAlign(arguments)
        }
        /// The observable state of the document
        @FocusedValue(\.document) private var document: FileDocumentConfiguration<ChordProDocument>?
        /// The body of the `View`
        var body: some View {
            VStack {
                RenderView.ImageView(
                    fileURL: document?.fileURL,
                    arguments: arguments,
                    scale: settings.scale.scale,
                    maxWidth: settings.scale.maxSongLineWidth
                )
            }
            .frame(maxWidth: settings.scale.maxSongLineWidth, alignment: alignment)
            .wrapSongSection(
                label: section.label,
                settings: settings
            )
        }
    }
}
