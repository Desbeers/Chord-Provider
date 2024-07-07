//
//  Song+RenderView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension Song {

    // MARK: Render a `Song` structure into a SwiftUI `View`

    /// Render a ``Song`` structure into a SwiftUI `View`
    struct RenderView: View {

        /// Init the RenderView
        /// - Parameters:
        ///   - song: The ``Song``
        ///   - options: The ``Song/DisplayOptions``
        init(song: Song, options: DisplayOptions) {
            self.song = song
            self.options = options
        }
        /// The ``Song``
        let song: Song
        /// The display options
        let options: DisplayOptions
        /// The body of the `View`
        var body: some View {
            switch options.paging {
            case .asList:
                VStack {
                    switch options.label {
                    case .inline:
                        VStack(alignment: .leading) {
                            sections
                        }
                        .scrollTargetLayout()
                    case .grid:
                        Grid(alignment: .topTrailing, verticalSpacing: 20 * options.scale) {
                            sections
                        }
                    }
                }
                .font(.system(size: 14 * options.scale))
            case .asColumns:
                ScrollView(.horizontal) {
                    ColumnsLayout(
                        columnSpacing: options.scale * 40,
                        rowSpacing: options.scale * 10
                    ) {
                        sections
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .frame(maxHeight: .infinity)
                .font(.system(size: 14 * options.scale))
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
}

extension Song.RenderView {

    /// Wrapper around a section
    struct SectionView: ViewModifier {
        /// The display options
        let options: Song.DisplayOptions
        /// The optional label
        var label: String = ""
        /// Bool if the section is prominent (chorus for example)
        var prominent: Bool = false

        /// The body of the `ViewModifier`
        /// - Parameter content: The content of the section
        /// - Returns: A `View` with the wrapped section
        func body(content: Content) -> some View {
            switch options.label {
            case .inline:
                VStack(alignment: .leading) {
                    if label.isEmpty {
                        content
                            .padding(.leading)
                    } else {
                        switch prominent {
                        case true:
                            ProminentLabel(
                                options: options,
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
                        .background(prominent ? Color.accentColor.opacity(0.3) : Color.clear, in: RoundedRectangle(cornerRadius: 4))
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
                    PartsView(options: options, sectionID: section.id, parts: line.parts, chords: song.chords)
                } else {
                    commentLabel(comment: line.comment)
                }
            }
        }
        .modifier(SectionView(options: options, label: section.label))
    }

    // MARK: Chorus

    /// SwiftUI `View` for a chorus section
    func chorusSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                if line.comment.isEmpty {
                    PartsView(options: options, sectionID: section.id, parts: line.parts, chords: song.chords)
                } else {
                    commentLabel(comment: line.comment)
                }
            }
        }
        .modifier(
            SectionView(
                options: options,
                label: section.label.isEmpty ? "Chorus" : section.label,
                prominent: true
            )
        )
    }

    /// SwiftUI `View` for a chorus repeat
    @ViewBuilder func repeatChorusSection(section: Song.Section) -> some View {

        if options.general.repeatWholeChorus, let lastChorus = song.sections.last(where: { $0.type == .chorus && $0.label == section.label }) {
            chorusSection(section: lastChorus)
        } else {
            ProminentLabel(
                options: options,
                label: section.label.isEmpty ? "Repeat Chorus" : section.label,
                icon: "arrow.triangle.2.circlepath"
            )
            .modifier(SectionView(options: options))
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
                        .minimumScaleFactor(0.01)
                        .monospaced()
                } else {
                    commentLabel(comment: line.comment)
                }
            }
        }
        .padding(.vertical, options.scale)
        .modifier(SectionView(options: options, label: section.label))
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
                                Text("|")
                                ForEach(grid.parts) { part in
                                    if let chord = song.chords.first(where: { $0.id == part.chord }) {
                                        ChordView(options: options, sectionID: section.id, partID: part.id, chord: chord)
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
        .padding(.vertical, options.scale)
        .modifier(SectionView(options: options, label: section.label))
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
        .frame(idealWidth: 400 * options.scale, maxWidth: 400 * options.scale, alignment: .leading)
        .modifier(SectionView(options: options, label: section.label == ChordPro.Environment.textblock.rawValue ? "" : section.label))
    }

    // MARK: Comment

    /// SwiftUI `View` for a comment in its own section
    func commentSection(section: Song.Section) -> some View {
        commentLabel(comment: section.lines.first?.comment ?? "")
            .modifier(SectionView(options: options))
    }

    /// SwiftUI `View` for a comment label
    func commentLabel(comment: String) -> some View {
        ProminentLabel(
            options: options,
            label: comment,
            icon: "text.bubble",
            color: .comment
        )
        .frame(idealWidth: 400 * options.scale, maxWidth: 400 * options.scale, alignment: .leading)
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
                    .tracking(2 * options.scale)
                    .monospaced()
                    .font(.system(size: 16 * options.scale))
                } else {
                    commentLabel(comment: line.comment)
                }
            }
        }
        .modifier(SectionView(options: options, label: section.label))
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
        .frame(idealWidth: 400 * options.scale, maxWidth: 400 * options.scale, alignment: .leading)
        .modifier(SectionView(options: options, label: section.label))
    }

    // MARK: Parts

    /// SwiftUI `View` for parts of a line
    struct PartsView: View {
        /// The display options
        let options: Song.DisplayOptions
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
                        if !options.general.lyricsOnly, let chord = chords.first(where: { $0.id == part.chord }) {
                            ChordView(options: options, sectionID: sectionID, partID: part.id, chord: chord)
                        }
                        /// See https://stackoverflow.com/questions/31534742/space-characters-being-removed-from-end-of-string-uilabel-swift
                        /// for the funny stuff added to the string...
                        Text("\(part.text)\u{200c}")
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, options.scale)
                }
            }
        }
    }

    /// SwiftUI `View` for a prominent label
    struct ProminentLabel: View {
        /// The display options
        let options: Song.DisplayOptions
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
            .padding(options.scale * 6)
            .background(color, in: RoundedRectangle(cornerRadius: 6))
        }
    }
}
