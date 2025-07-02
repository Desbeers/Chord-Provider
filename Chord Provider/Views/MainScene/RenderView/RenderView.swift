//
//  RenderView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

enum RenderView {
    // Just a placeholder
}

extension RenderView {

    /// Render a ``Song`` structure into a SwiftUI `View`
    struct MainView: View {
        /// The ``Song``
        let song: Song
        /// The calculated spacing between sections
        let spacing: Double
        /// Init the `View`
        /// - Parameters:
        ///   - song: The ``Song`` to view
        ///   - scale: The scale of the `View`
        init(
            song: Song,
            scale: AppSettings.Scale
        ) {
            self.spacing = 20 * scale.scale
            var song = song
            song.settings.scale = scale
            /// Calculate label style
            switch song.settings.display.paging {
            case .asColumns:
                song.settings.display.labelStyle = .inline
            case .asList:
                let neededWidth = (scale.maxSongLabelWidth + scale.maxSongLineWidth) + (2 * self.spacing) + 20
                song.settings.display.labelStyle = scale.maxSongWidth < neededWidth ? .inline : .grid
            }
            self.song = song
        }
        /// The body of the `View`
        var body: some View {
            switch song.settings.display.paging {
            case .asList:
                ScrollView(.vertical) {
                    switch song.settings.display.labelStyle {
                    case .grid:
                        LazyVGrid(
                            columns: [
                                GridItem(.fixed(song.settings.scale.maxSongLabelWidth), alignment: .topTrailing),
                                GridItem(.fixed(10), alignment: .center),
                                GridItem(.flexible(minimum: 100, maximum: song.settings.scale.maxSongLineWidth), alignment: .topLeading)
                            ],
                            alignment: .center,
                            spacing: spacing
                        ) {
                            RenderView.Sections(sections: song.sections, chords: song.chords, settings: song.settings)
                        }
                        .padding(.vertical, spacing)
                    case .inline:
                        LazyVStack(alignment: .leading) {
                            RenderView.Sections(sections: song.sections, chords: song.chords, settings: song.settings)
                        }
                        .padding(spacing)
                    }
                }
            case .asColumns:
                ScrollView(.horizontal) {
                    ColumnsLayout(
                        columnSpacing: spacing * 2,
                        rowSpacing: spacing * 0.5
                    ) {
                        RenderView.Sections(sections: song.sections, chords: song.chords, settings: song.settings)
                    }
                    .padding(spacing)
                }
            }
        }
    }
}

extension RenderView {

    /// Get flush from the arguments
    /// - Parameter arguments: The arguments of the directive
    /// - Returns: The flush alignment
    static func getFlush(_ arguments: ChordProParser.DirectiveArguments?) -> HorizontalAlignment {
        if let flush = arguments?[.flush] {
            switch flush {
            case "center":
                return .center
            case "right":
                return .trailing
            default:
                return .leading
            }
        }
        return .leading
    }

    /// Get alignment from the arguments
    /// - Parameter arguments: The arguments of the directive
    /// - Returns: The alignment
    static func getAlign(_ arguments: ChordProParser.DirectiveArguments?) -> Alignment {
        if let align = arguments?[.align] {
            switch align {
            case "center":
                return .center
            case "right":
                return .trailing
            default:
                return .leading
            }
        }
        return .leading
    }

    /// Get text flush from the arguments
    /// - Parameter arguments: The arguments of the directive
    /// - Returns: The text flush alignment
    static func getTextFlush(_ arguments: ChordProParser.DirectiveArguments?) -> TextAlignment {
        if let flush = arguments?[.flush] {
            switch flush {
            case "center":
                return .center
            case "right":
                return .trailing
            default:
                return .leading
            }
        }
        return .leading
    }
}
