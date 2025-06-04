//
//  RenderView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

// MARK: Render a `Song` structure into a SwiftUI `View`

/// Render a ``Song`` structure into a SwiftUI `View`
struct RenderView: View {

    /// The ``Song``
    let song: Song

    /// Init the `View`
    /// - Parameters:
    ///   - song: The ``Song`` to view
    ///   - labelStyle: The option for the label style of the song
    ///
    /// The **labelStyle** can depend on the available space when viewing as a list.
    /// It is using a `ViewThatFits` for that in ``SongView``.
    init(
        song: Song,
        labelStyle: AppSettings.Display.LabelStyle
    ) {
        var song = song
        song.settings.display.labelStyle = labelStyle
        self.song = song
    }

    /// The body of the `View`
    var body: some View {

        switch song.settings.display.paging {
        case .asList:
            VStack {
                switch song.settings.display.labelStyle {
                case .inline:
                    sections
                case .grid:
                    Grid(alignment: .topTrailing, verticalSpacing: 20 * song.settings.scale) {
                        sections
                    }
                }
            }
            .font(song.settings.style.fonts.text.swiftUIFont(scale: song.settings.scale))
        case .asColumns:
            ScrollView(.horizontal) {
                ColumnsLayout(
                    columnSpacing: song.settings.scale * 40,
                    rowSpacing: song.settings.scale * 10
                ) {
                    sections
                }
                .padding(song.settings.scale * 20)
            }
            .frame(maxHeight: .infinity)
            .font(song.settings.style.fonts.text.swiftUIFont(scale: song.settings.scale))
        }
    }
}

extension RenderView {

    /// Get flush from the arguments
    /// - Parameter arguments: The arguments of the directive
    /// - Returns: The flush alignment
    func getFlush(_ arguments: ChordProParser.DirectiveArguments?) -> HorizontalAlignment {
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
    func getAlign(_ arguments: ChordProParser.DirectiveArguments?) -> Alignment {
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
    func getTextFlush(_ arguments: ChordProParser.DirectiveArguments?) -> TextAlignment {
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
