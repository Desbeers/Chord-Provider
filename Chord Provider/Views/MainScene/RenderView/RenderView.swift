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
        /// The ``AppSettings``
        let settings: AppSettings
        /// The calculated spacing between sections
        let spacing: Double
        /// Init the `View`
        /// - Parameters:
        ///   - song: The ``Song`` to view
        ///   - settings: The ``AppSettings``
        init(song: Song, settings: AppSettings) {
            self.spacing = 20 * settings.scale.magnifier
            var settings = settings
            /// Calculate label style
            switch settings.display.paging {
            case .asColumns:
                settings.display.labelStyle = .inline
            case .asList:
                let neededWidth = (settings.scale.maxSongLabelWidth + settings.scale.maxSongLineWidth) + (2 * self.spacing) + 20
                settings.display.labelStyle = settings.scale.maxSongWidth < neededWidth ? .inline : .grid
            }
            self.song = song
            self.settings = settings
        }
        /// The body of the `View`
        var body: some View {
            switch settings.display.paging {
            case .asList:
                ScrollView(.vertical) {
                    switch settings.display.labelStyle {
                    case .grid:
                        LazyVGrid(
                            columns: [
                                GridItem(.fixed(settings.scale.maxSongLabelWidth), alignment: .topTrailing),
                                GridItem(.fixed(10), alignment: .center),
                                GridItem(.flexible(minimum: 100, maximum: settings.scale.maxSongLineWidth), alignment: .topLeading)
                            ],
                            alignment: .center,
                            spacing: spacing
                        ) {
                            RenderView.Sections(sections: song.sections, chords: song.chords, settings: settings)
                        }
                        .padding(.vertical, spacing)
                    case .inline:
                        LazyVStack(alignment: .leading) {
                            RenderView.Sections(sections: song.sections, chords: song.chords, settings: settings)
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
                        RenderView.Sections(sections: song.sections, chords: song.chords, settings: settings)
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
