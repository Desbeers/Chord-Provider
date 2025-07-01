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

        /// Init the `View`
        /// - Parameters:
        ///   - song: The ``Song`` to view
        ///   - labelStyle: The option for the label style of the song
        ///   - scale: The scale of the `View`
        ///
        /// The **labelStyle** can depend on the available space when viewing as a list.
        /// It is using a `ViewThatFits` for that in ``SongView``.
        init(
            song: Song,
            //labelStyle: AppSettings.Display.LabelStyle,
            scale: AppSettings.Scale
        ) {
            print("INIT MAINSONG!!!")
            print(scale.maxSongWidth)
            print(scale.maxSongLabelWidth + scale.maxSongLineWidth)

            var song = song
            song.settings.scale = scale
            //song.settings.display.labelStyle = labelStyle

            switch song.settings.display.paging {
            case .asColumns:
                song.settings.display.labelStyle = .inline
            case .asList:

                song.settings.display.labelStyle = scale.maxSongWidth < (scale.maxSongLabelWidth + scale.maxSongLineWidth) ? .inline : .grid
            }


            self.song = song
        }

        /// The body of the `View`
        var body: some View {
            switch song.settings.display.paging {
            case .asList:
                    switch song.settings.display.labelStyle {
                    case .grid:
                        LazyVGrid(
                            columns: [

                                GridItem(.fixed(song.settings.scale.maxSongLabelWidth), alignment: .topTrailing),
                                GridItem(.fixed(10), alignment: .center),
                                GridItem(.flexible(minimum: 100, maximum: song.settings.scale.maxSongLineWidth), alignment: .topLeading),

//                                GridItem(.fixed(song.settings.scale.maxSongLabelWidth)),
//                                GridItem(.fixed(song.settings.scale.maxSongLineWidth)),
                            ],
                            alignment: .center,
                            spacing: 10
                        ) {
                            RenderView.Sections(sections: song.sections, chords: song.chords, settings: song.settings)
                        }
                        //.background(Color.randomLight)
                    case .inline:
                        LazyVStack(alignment: .leading) {
                            RenderView.Sections(sections: song.sections, chords: song.chords, settings: song.settings)
                        }
                        .padding(song.settings.scale.scale * 20)
                    }
            case .asColumns:
                ScrollView(.horizontal) {
                    ColumnsLayout(
                        columnSpacing: song.settings.scale.scale * 40,
                        rowSpacing: song.settings.scale.scale * 10
                    ) {
                        RenderView.Sections(sections: song.sections, chords: song.chords, settings: song.settings)
                    }
                    .padding(song.settings.scale.scale * 20)
                }
                .frame(maxHeight: .infinity)
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
