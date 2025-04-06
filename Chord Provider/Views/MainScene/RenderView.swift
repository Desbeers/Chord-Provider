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

    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState

    /// Init the `View`
    /// - Parameters:
    ///   - song: The ``Song
    ///   - paging: The option for the paging
    ///   - labelStyle: The option for the label style
    init(
        song: Song,
        paging: AppSettings.SongDisplayOptions.Paging,
        labelStyle: AppSettings.SongDisplayOptions.LabelStyle
    ) {
        var song = song
        let viewSettings = AppSettings.SongDisplayOptions(
            repeatWholeChorus: song.settings.display.repeatWholeChorus,
            lyricsOnly: song.settings.display.lyricsOnly,
            paging: paging,
            labelStyle: labelStyle,
            chords: song.settings.display.showInlineDiagrams ? .asDiagram : .asName,
            instrument: song.settings.display.instrument
        )
        song.settings.display = viewSettings
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
                    Grid(alignment: .topTrailing, verticalSpacing: 20 * song.scale) {
                        sections
                    }
                }
            }
            .font(appState.settings.style.fonts.text.swiftUIFont(scale: song.scale))
        case .asColumns:
            ScrollView(.horizontal) {
                ColumnsLayout(
                    columnSpacing: song.scale * 40,
                    rowSpacing: song.scale * 10
                ) {
                    sections
                }
                .padding(song.scale * 20)
            }
            .frame(maxHeight: .infinity)
            .font(appState.settings.style.fonts.text.swiftUIFont(scale: song.scale))
        }
    }

    /// The sections of the `View`
    var sections: some View {
        ForEach(song.sections) { section in
            switch section.environment {
            case .verse, .bridge:
                verseSection(section: section)
            case .chorus:
                chorusSection(section: section)
            case .repeatChorus:
                repeatChorusSection(section: section)
            case .tab:
                if !appState.settings.song.display.lyricsOnly {
                    tabSection(section: section)
                }
            case .grid:
                if !appState.settings.song.display.lyricsOnly {
                    gridSection(section: section)
                }
            case .textblock:
                textblockSection(section: section)
            case .abc:
                /// Not supported
                EmptyView()
            case .comment:
                commentSection(section: section)
            case .strum:
                if !appState.settings.song.display.lyricsOnly {
                    strumSection(section: section)
                }
            case .image:
                imageSection(section: section)
            case .metadata:
                /// Don't render metadata
                EmptyView()
            case .none:
                /// Not an environment
                EmptyView()
            }
        }
    }
}

extension RenderView {

    /// Wrapper around a section
    struct SectionView: ViewModifier {
        /// The observable state of the application
        @Environment(AppStateModel.self) private var appState
        /// The ``Song``
        var song: Song
        /// The optional label
        var label: String = ""
        /// Bool if the section is prominent (chorus for example)
        var prominent: Bool = false
        /// The calculated font
        var font: Font {
            appState.settings.style.fonts.label.swiftUIFont(scale: song.scale)
        }
        /// The body of the `ViewModifier`
        /// - Parameter content: The content of the section
        /// - Returns: A `View` with the wrapped section
        func body(content: Content) -> some View {
            switch song.settings.display.labelStyle {
            case .inline:
                Group {
                    /// - Note: For best performance, use `LazyVStack` for  the list view
                    switch song.settings.display.paging {
                    case .asList:
                        LazyVStack(alignment: .leading) {
                            inlineContent(content: content)
                        }
                    case .asColumns:
                        VStack(alignment: .leading) {
                            inlineContent(content: content)
                        }
                    }
                }
                .padding(.top)
                .frame(minWidth: song.maxWidth, idealWidth: song.maxWidth, maxWidth: song.maxWidth, alignment: .leading)
            case .grid:
                GridRow {
                    Group {
                        switch prominent {
                        case true:
                            ProminentLabel(
                                song: song,
                                label: label,
                                font: font
                            )
                        case false:
                            Text(label)
                                .font(font)
                        }
                    }
                    .foregroundStyle(appState.settings.style.fonts.label.color, appState.settings.style.fonts.label.background)
                    .frame(minWidth: 100, alignment: .trailing)
                    .gridColumnAlignment(.trailing)
                    content
                        .frame(minWidth: song.maxWidth, idealWidth: song.maxWidth, maxWidth: song.maxWidth, alignment: .leading)
                        .padding(.leading)
                        .overlay(
                            Rectangle()
                                .frame(width: 1, height: nil, alignment: .leading)
                                .foregroundStyle(
                                    prominent || !label.isEmpty ? appState.settings.style.theme.foregroundMedium.opacity(0.3) : Color.clear
                                ),
                            alignment: .leading
                        )
                        .gridColumnAlignment(.leading)
                }
            }
        }
        /// The content of the section when viewed inline
        @ViewBuilder func inlineContent(content: Content) -> some View {
            if label.isEmpty {
                content
                    .padding(.leading)
            } else {
                Group {
                    switch prominent {
                    case true:
                        ProminentLabel(
                            song: song,
                            label: label,
                            font: font
                        )
                    case false:
                        Text(label)
                            .font(font)
                    }
                }
                .foregroundStyle(appState.settings.style.fonts.label.color, appState.settings.style.fonts.label.background)
                Divider()
                content
                    .padding(.leading)
            }
        }
    }

    // MARK: Verse

    /// SwiftUI `View` for a verse section
    func verseSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    if let parts = line.parts {
                        PartsView(
                            song: song,
                            sectionID: section.id,
                            parts: parts,
                            chords: song.chords
                        )
                    }
                case .comment:
                    commentLabel(comment: line.plain)
                default:
                    EmptyView()
                }
            }
        }
        .modifier(
            SectionView(
                song: song,
                label: section.label
            )
        )
    }

    // MARK: Chorus

    /// SwiftUI `View` for a chorus section
    func chorusSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    if let parts = line.parts {
                        PartsView(
                            song: song,
                            sectionID: section.id,
                            parts: parts,
                            chords: song.chords
                        )
                    }
                case .comment:
                    commentLabel(comment: line.plain)
                default:
                    EmptyView()
                }
            }
        }
        .modifier(
            SectionView(
                song: song,
                label: section.label.isEmpty ? "Chorus" : section.label,
                prominent: true
            )
        )
    }

    /// SwiftUI `View` for a chorus repeat
    @ViewBuilder func repeatChorusSection(section: Song.Section) -> some View {
        if
            song.settings.display.repeatWholeChorus,
            let lastChorus = song.sections.last(where: { $0.environment == .chorus && $0.label == section.label }) {
            chorusSection(section: lastChorus)
        } else {
            ProminentLabel(
                song: song,
                label: section.label,
                icon: "arrow.triangle.2.circlepath",
                font: appState.settings.style.fonts.label.swiftUIFont(scale: song.scale)
            )
            .foregroundStyle(appState.settings.style.fonts.label.color, appState.settings.style.fonts.label.background)
            .frame(alignment: .leading)
            .modifier(SectionView(song: song))
        }
    }

    // MARK: Tab

    /// SwiftUI `View` for a tab section
    func tabSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    Text(line.plain)
                        .lineLimit(1)
                        .monospaced()
                        .minimumScaleFactor(0.1)
                case .comment:
                    commentLabel(comment: line.plain)
                default:
                    EmptyView()
                }
            }
        }
        .padding(.vertical, song.scale)
        .modifier(SectionView(song: song, label: section.label))
    }

    // MARK: Grid

    /// SwiftUI `View` for a grid section
    func gridSection(section: Song.Section) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Grid(alignment: .leading) {
                ForEach(section.lines) { line in
                    switch line.directive {
                    case .environmentLine:
                        if let grids = line.grid {
                            GridRow {
                                ForEach(grids) { grid in
                                    ForEach(grid.parts) { part in
                                        if let chord = song.chords.first(where: { $0.id == part.chord }) {
                                            ChordView(
                                                settings: song.settings,
                                                sectionID: section.id,
                                                partID: part.id,
                                                chord: chord
                                            )
                                        } else {
                                            Text(part.text)
                                                .foregroundStyle(part.text == "|" || part.text == "." ? Color.primary : Color.red)
                                        }
                                    }
                                }
                            }
                        }
                    case .comment:
                        commentLabel(comment: line.plain)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .padding(.vertical, song.scale)
        .modifier(SectionView(song: song, label: section.label))
    }

    // MARK: Textblock

    /// SwiftUI `View` for a plain text section
    func textblockSection(section: Song.Section) -> some View {
        VStack(alignment: getFlush(section.arguments)) {
            if !section.label.isEmpty {
                Text(section.label)
                    .foregroundStyle(appState.settings.style.fonts.label.color)
                    .font(appState.settings.style.fonts.label.swiftUIFont(scale: song.scale))
                Divider()
            }
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    if let parts = line.parts {
                        HStack(spacing: 0) {
                            ForEach(parts) { part in
                                if let chord = song.chords.first(where: { $0.id == part.chord }) {
                                    ChordView(settings: song.settings, sectionID: section.id, partID: part.id, chord: chord)
                                }
                                /// Init the text like this to enable markdown formatting
                                Text(.init(part.text))
                            }
                        }
                        .foregroundStyle(appState.settings.style.fonts.textblock.color)
                        .font(appState.settings.style.fonts.textblock.swiftUIFont(scale: song.scale))
                    }
                case .comment:
                    Label(line.label, systemImage: "text.bubble")
                        .font(appState.settings.style.fonts.comment.swiftUIFont(scale: song.scale))
                        .foregroundStyle(appState.settings.style.fonts.comment.color)
                default:
                    EmptyView()
                }
            }
        }
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
        .multilineTextAlignment(getTextFlush(section.arguments))
        .frame(minWidth: song.maxWidth, idealWidth: song.maxWidth, maxWidth: song.maxWidth, alignment: getAlign(section.arguments))
        .modifier(
            SectionView(song: song)
        )
    }

    // MARK: Comment

    /// SwiftUI `View` for a comment in its own section
    func commentSection(section: Song.Section) -> some View {
        commentLabel(comment: section.lines.first?.plain ?? "")
            .modifier(SectionView(song: song))
    }

    /// SwiftUI `View` for a comment label
    @ViewBuilder func commentLabel(comment: String) -> some View {
        ProminentLabel(
            song: song,
            label: comment,
            icon: "text.bubble",
            font: appState.settings.style.fonts.comment.swiftUIFont(scale: song.scale)
        )
        .foregroundStyle(appState.settings.style.fonts.comment.color, appState.settings.style.fonts.comment.background)
        .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: Strum

    /// SwiftUI `View` for a strum section
    func strumSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    if let strums = line.strum {
                        ForEach(strums) {strum in
                            Text(strum)
                        }
                        .tracking(2 * song.scale)
                        .monospaced()
                    }
                case .comment:
                    commentLabel(comment: line.plain)
                default:
                    EmptyView()
                }
            }
        }
        .modifier(SectionView(song: song, label: section.label))
    }

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
                scale: song.scale,
                maxWidth: song.maxWidth
            )
        }
        .frame(maxWidth: song.maxWidth, alignment: getAlign(arguments))
        .modifier(SectionView(song: song))
    }

    // MARK: Parts

    /// SwiftUI `View` for parts of a line
    struct PartsView: View {
        /// The observable state of the application
        @Environment(AppStateModel.self) private var appState
        /// The ``Song``
        let song: Song
        /// The ID of the section
        let sectionID: Int
        /// The `parts` of a `line`
        let parts: [Song.Section.Line.Part]
        /// The chords of the song
        let chords: [ChordDefinition]
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(parts) { part in
                    VStack(alignment: .leading) {
                        if !song.settings.display.lyricsOnly, let chord = chords.first(where: { $0.id == part.chord }) {
                            ChordView(settings: song.settings, sectionID: sectionID, partID: part.id, chord: chord)
                        } else if !song.settings.display.lyricsOnly {
                            /// A line without a chord
                            Text(" ")
                                .font(appState.settings.style.fonts.chord.swiftUIFont(scale: song.scale))
                        }
                        /// See https://stackoverflow.com/questions/31534742/space-characters-being-removed-from-end-of-string-uilabel-swift
                        /// for the funny stuff added to the string...
                        Text("\(part.text)\u{200c}")
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, song.scale)
                }
            }
        }
    }
}

extension RenderView {

    /// Get flush from the arguments
    /// - Parameter arguments: The arguments of the directive
    /// - Returns: The flush alignment
    func getFlush(_ arguments: ChordProParser.Arguments?) -> HorizontalAlignment {
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
    func getAlign(_ arguments: ChordProParser.Arguments?) -> Alignment {
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
    func getTextFlush(_ arguments: ChordProParser.Arguments?) -> TextAlignment {
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
