//
//  RenderView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

// MARK: Render a `Song` structure into a SwiftUI `View`

/// Render a ``Song`` structure into a SwiftUI `View`
struct RenderView: View {

    /// The ``Song``
    let song: Song

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
            repeatWholeChorus: song.settings.song.repeatWholeChorus,
            lyricsOnly: song.settings.song.lyricsOnly,
            paging: paging,
            labelStyle: labelStyle,
            scale: song.settings.song.scale,
            chords: song.settings.song.showInlineDiagrams ? .asDiagram : .asName,
            instrument: song.settings.song.instrument
        )
        song.settings.song = viewSettings
        self.song = song
    }

    /// The body of the `View`
    var body: some View {
        switch song.settings.song.paging {
        case .asList:
            VStack {
                switch song.settings.song.labelStyle {
                case .inline:
                    sections
                        .scrollTargetLayout()
                case .grid:
                    Grid(alignment: .topTrailing, verticalSpacing: 20 * song.settings.song.scale) {
                        sections
                    }
                }
            }
            .font(.system(size: 14 * song.settings.song.scale))
        case .asColumns:
            ScrollView(.horizontal) {
                ColumnsLayout(
                    columnSpacing: song.settings.song.scale * 40,
                    rowSpacing: song.settings.song.scale * 10
                ) {
                    sections
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .frame(maxHeight: .infinity)
            .font(.system(size: 14 * song.settings.song.scale))
        }
    }

    /// The sections of the `View`
    var sections: some View {
        ForEach(song.sections) { section in
            switch section.type {
            case .verse, .bridge:
                verseSection(section: section)
            case .chorus:
                chorusSection(section: section)
            case .repeatChorus:
                repeatChorusSection(section: section)
            case .tab:
                tabSection(section: section)
            case .grid:
                gridSection(section: section)
            case .textblock:
                textblockSection(section: section)
            case .comment:
                commentSection(section: section)
            case .strum:
                strumSection(section: section)
            default:
                plainSection(section: section)
            }
        }
    }
}

extension RenderView {

    /// Wrapper around a section
    struct SectionView: ViewModifier {
        /// The display options
        let settings: AppSettings
        /// The optional label
        var label: String = ""
        /// Bool if the section is prominent (chorus for example)
        var prominent: Bool = false

        /// The body of the `ViewModifier`
        /// - Parameter content: The content of the section
        /// - Returns: A `View` with the wrapped section
        func body(content: Content) -> some View {
            switch settings.song.labelStyle {
            case .inline:
                VStack(alignment: .leading) {
                    if label.isEmpty {
                        content
                            .padding(.leading)
                    } else {
                        switch prominent {
                        case true:
                            ProminentLabel(
                                settings: settings,
                                label: label
                            )
                        case false:
                            Text(label)
                        }
                        Divider()
                        content
                            .padding(.leading)
                    }
                }
                .padding(.top)
            case .grid:
                GridRow {
                    Text(label)
                        .padding(.all, prominent ? 10 : 0)
                        .background(
                            prominent ? Color.accentColor.opacity(0.3) : Color.clear,
                            in: RoundedRectangle(cornerRadius: 4)
                        )
                        .frame(minWidth: 100, alignment: .trailing)
                        .gridColumnAlignment(.trailing)
                    content
                        .padding(.leading)
                        .overlay(
                            Rectangle()
                                .frame(width: 1, height: nil, alignment: .leading)
                                .foregroundStyle(
                                    prominent || !label.isEmpty ? Color.secondary.opacity(0.3) : Color.clear
                                ),
                            alignment: .leading
                        )
                        .gridColumnAlignment(.leading)
                }
            }
        }
    }

    // MARK: Verse

    /// SwiftUI `View` for a verse section
    func verseSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                if line.comment.isEmpty {
                    PartsView(settings: song.settings, sectionID: section.id, parts: line.parts, chords: song.chords)
                } else {
                    commentLabel(comment: line.comment)
                }
            }
        }
        .modifier(SectionView(settings: song.settings, label: section.label))
    }

    // MARK: Chorus

    /// SwiftUI `View` for a chorus section
    func chorusSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                if line.comment.isEmpty {
                    PartsView(
                        settings: song.settings,
                        sectionID: section.id,
                        parts: line.parts,
                        chords: song.chords
                    )
                } else {
                    commentLabel(comment: line.comment)
                }
            }
        }
        .modifier(
            SectionView(
                settings: song.settings,
                label: section.label.isEmpty ? "Chorus" : section.label,
                prominent: true
            )
        )
    }

    /// SwiftUI `View` for a chorus repeat
    @ViewBuilder func repeatChorusSection(section: Song.Section) -> some View {
        if
            song.settings.song.repeatWholeChorus,
            let lastChorus = song.sections.last(where: { $0.type == .chorus && $0.label == section.label }) {
            chorusSection(section: lastChorus)
        } else {
            ProminentLabel(
                settings: song.settings,
                label: section.label.isEmpty ? "Repeat Chorus" : section.label,
                icon: "arrow.triangle.2.circlepath"
            )
            .modifier(SectionView(settings: song.settings))
        }
    }

    // MARK: Tab

    /// SwiftUI `View` for a tab section
    func tabSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                if line.comment.isEmpty {
                    Text(line.tab)
                        .lineLimit(1)
                        .monospaced()
                        .minimumScaleFactor(0.1)
                } else {
                    commentLabel(comment: line.comment)
                }
            }
        }
        .padding(.vertical, song.settings.song.scale)
        .modifier(SectionView(settings: song.settings, label: section.label))
    }

    // MARK: Grid

    /// SwiftUI `View` for a grid section
    func gridSection(section: Song.Section) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Grid(alignment: .leading) {
                ForEach(section.lines) { line in
                    if line.comment.isEmpty {
                        GridRow {
                            ForEach(line.grid) { grid in
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
                                    }
                                }
                            }
                        }
                    } else {
                        commentLabel(comment: line.comment)
                    }
                }
            }
        }
        .padding(.vertical, song.settings.song.scale)
        .modifier(SectionView(settings: song.settings, label: section.label))
    }

    // MARK: Textblock

    /// SwiftUI `View` for a plain text section
    func textblockSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                ForEach(line.parts) { part in
                    /// Init the text like this to enable markdown formatting
                    Text(.init(part.text.trimmingCharacters(in: .whitespacesAndNewlines)))
                }
            }
        }
        .foregroundStyle(.secondary)
        .frame(idealWidth: 400 * song.settings.song.scale, maxWidth: 400 * song.settings.song.scale, alignment: .leading)
        .modifier(
            SectionView(
                settings: song.settings,
                label: section.label == ChordPro.Environment.textblock.rawValue ? "" : section.label
            )
        )
    }

    // MARK: Comment

    /// SwiftUI `View` for a comment in its own section
    func commentSection(section: Song.Section) -> some View {
        commentLabel(comment: section.lines.first?.comment ?? "")
            .modifier(SectionView(settings: song.settings))
    }

    /// SwiftUI `View` for a comment label
    func commentLabel(comment: String) -> some View {
        ProminentLabel(
            settings: song.settings,
            label: comment,
            icon: "text.bubble",
            color: .comment
        )
        .frame(idealWidth: 400 * song.settings.song.scale, maxWidth: 400 * song.settings.song.scale, alignment: .leading)
    }

    // MARK: Strum

    /// SwiftUI `View` for a strum section
    func strumSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                if line.comment.isEmpty {
                    ForEach(line.strum) {strum in
                        Text(strum)
                    }
                    .tracking(2 * song.settings.song.scale)
                    .monospaced()
                    .font(.system(size: 16 * song.settings.song.scale))
                } else {
                    commentLabel(comment: line.comment)
                }
            }
        }
        .modifier(SectionView(settings: song.settings, label: section.label))
    }

    // MARK: Plain

    /// SwiftUI `View` for a plain text section
    func plainSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                ForEach(line.parts) { part in
                    /// Init the text like this to enable markdown formatting
                    Text(.init(part.text.trimmingCharacters(in: .whitespacesAndNewlines)))
                }
            }
        }
        .frame(idealWidth: 400 * song.settings.song.scale, maxWidth: 400 * song.settings.song.scale, alignment: .leading)
        .modifier(SectionView(settings: song.settings, label: section.label))
    }

    // MARK: Parts

    /// SwiftUI `View` for parts of a line
    struct PartsView: View {
        /// The display options
        let settings: AppSettings
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
                        if !settings.song.lyricsOnly, let chord = chords.first(where: { $0.id == part.chord }) {
                            ChordView(settings: settings, sectionID: sectionID, partID: part.id, chord: chord)
                        }
                        /// See https://stackoverflow.com/questions/31534742/space-characters-being-removed-from-end-of-string-uilabel-swift
                        /// for the funny stuff added to the string...
                        Text("\(part.text)\u{200c}")
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, settings.song.scale)
                }
            }
        }
    }

    /// SwiftUI `View` for a prominent label
    struct ProminentLabel: View {
        /// The display options
        let settings: AppSettings
        /// The label
        let label: String
        /// The optional icon
        var icon: String?
        /// The color of the label
        var color: Color = .accentColor.opacity(0.3)
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
                        }
                    )
                } else {
                    Text(.init(label))
                }
            }
            .padding(settings.song.scale * 6)
            .background(color, in: RoundedRectangle(cornerRadius: 6))
        }
    }
}
