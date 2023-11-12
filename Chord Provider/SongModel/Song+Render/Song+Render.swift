//
//  Song+Render.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension Song {

    /// Render a ``Song`` struct into a SwiftUI View
    struct Render: View {
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
                    .padding()
                }
                .frame(maxHeight: .infinity)
                .font(.system(size: 14 * options.scale))
            }
        }

        /// The sections of the `View`
        var sections: some View {
            ForEach(song.sections) { section in
                switch section.type {
                case .verse, .bridge:
                    VerseSectionView(section: section, options: options, chords: song.chords)
                case .chorus:
                    ChorusSectionView(section: section, options: options, chords: song.chords)
                case .repeatChorus:
                    RepeatChorusView(section: section, options: options)
                case .tab:
                    TabSectionView(section: section, options: options)
                case .grid:
                    GridSectionView(section: section, options: options, chords: song.chords)
                case .comment:
                    CommentSectionView(section: section, options: options)
                case .strum:
                    StrumSectionView(section: section, options: options)
                default:
                    PlainSectionView(section: section, options: options)
                }
            }
        }
    }
}

extension Song.Render {

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
                            ProminentLabel(options: options, label: label)
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
                                .foregroundColor(
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
    struct VerseSectionView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The display options
        let options: Song.DisplayOptions
        /// The chords of the song
        let chords: [ChordDefinition]
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    if line.comment.isEmpty {
                        PartsView(options: options, sectionID: section.id, parts: line.parts, chords: chords)
                    } else {
                        CommentLabelView(comment: line.comment, options: options)
                    }
                }
            }
            .modifier(SectionView(options: options, label: section.label))
        }
    }

    // MARK: Chorus

    /// SwiftUI `View` for a chorus section
    struct ChorusSectionView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The display options
        let options: Song.DisplayOptions
        /// The chords of the song
        let chords: [ChordDefinition]
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    if line.comment.isEmpty {
                        PartsView(options: options, sectionID: section.id, parts: line.parts, chords: chords)
                    } else {
                        CommentLabelView(comment: line.comment, options: options)
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
    }

    /// SwiftUI `View` for a chorus repeat
    struct RepeatChorusView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The display options
        let options: Song.DisplayOptions
        /// The body of the `View`
        var body: some View {
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
    struct TabSectionView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The display options
        let options: Song.DisplayOptions
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    if line.comment.isEmpty {
                        Text(line.tab)
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .monospaced()
                    } else {
                        CommentLabelView(comment: line.comment, options: options)
                    }
                }
            }
            .padding(.vertical, options.scale)
            .modifier(SectionView(options: options, label: section.label))
        }
    }

    // MARK: Grid

    /// SwiftUI `View` for a grid section
    struct GridSectionView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The display options
        let options: Song.DisplayOptions
        /// The chords of the song
        let chords: [ChordDefinition]
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Grid(alignment: .leading) {
                    ForEach(section.lines) { line in
                        if line.comment.isEmpty {
                            GridRow {
                                ForEach(line.grid) { grid in
                                    Text("|")
                                    ForEach(grid.parts) { part in
                                        if let chord = chords.first(where: { $0.id == part.chord }) {
                                            ChordView(options: options, sectionID: section.id, partID: part.id, chord: chord)
                                        } else {
                                            Text(part.text)
                                        }
                                    }
                                }
                            }
                        } else {
                            CommentLabelView(comment: line.comment, options: options)
                        }
                    }
                }
            }
            .padding(.vertical, options.scale)
            .modifier(SectionView(options: options, label: section.label))
        }
    }

    // MARK: Comment

    /// SwiftUI `View` for a comment in its own section
    struct CommentSectionView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The display options
        let options: Song.DisplayOptions
        /// The body of the `View`
        var body: some View {
            CommentLabelView(comment: section.lines.first?.comment ?? "", options: options)
                .modifier(SectionView(options: options))
        }
    }

    /// SwiftUI `View` for a comment label
    struct CommentLabelView: View {
        /// The comment
        let comment: String
        /// The display options
        let options: Song.DisplayOptions
        /// The body of the `View`
        var body: some View {
            ProminentLabel(options: options, label: comment, icon: "text.bubble", color: .yellow)
                .italic()
        }
    }

    // MARK: Strum

    /// SwiftUI `View` for a strum section
    struct StrumSectionView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The display options
        let options: Song.DisplayOptions
        /// The body of the `View`
        var body: some View {
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
                        CommentLabelView(comment: line.comment, options: options)
                    }
                }
            }
            .modifier(SectionView(options: options, label: section.label))
        }
    }

    // MARK: Plain

    /// SwiftUI `View` for a plain text section
    struct PlainSectionView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The display options
        let options: Song.DisplayOptions
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    ForEach(line.parts) { part in
                        Text(part.text.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                }
            }
            .frame(idealWidth: 400 * options.scale, maxWidth: 400 * options.scale, alignment: .leading)
            .modifier(SectionView(options: options, label: section.label))
        }
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
                        if let chord = chords.first(where: { $0.id == part.chord }) {
                            ChordView(options: options, sectionID: sectionID, partID: part.id, chord: chord)
                        }
                        Text(part.text)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, options.scale)
                    /// Don't truncate text
                    .fixedSize(horizontal: true, vertical: false)
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
        var color: Color = .accentColor
        var body: some View {
            if let icon {
                Label(
                    title: {
                        Text(.init(label))
                    },
                    icon: {
                        Image(systemName: icon)
                    }
                )
                .padding(options.scale * 6)
                .background(color.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
            } else {
                Text(.init(label))
                    .padding(options.scale * 6)
                    .background(color.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
            }
        }
    }
}

extension String: Identifiable {

    // swiftlint:disable type_name
    /// Make a String identifiable
    public typealias ID = Int
    /// The ID of the string
    public var id: Int {
        hash
    }
    // swiftlint:enable type_name
}
