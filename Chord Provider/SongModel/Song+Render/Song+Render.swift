//
//  Song+Render.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities
import FrameUp

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
                GeometryReader { geometry in
                    ScrollView(.horizontal) {
                        VFlow(
                            alignment: .topLeading,
                            maxHeight: geometry.size.height * 0.95,
                            horizontalSpacing: options.scale * 40,
                            verticalSpacing: options.scale * 10
                        ) {
                            sections
                        }
                        .padding()
                        Spacer()
                    }
                    .font(.system(size: 14 * options.scale))
                }
            }
        }

        /// The sections of the `View`
        var sections: some View {
            ForEach(song.sections) { section in
                switch section.type {
                case .verse, .bridge:
                    VerseView(section: section, options: options, chords: song.chords)
                case .chorus:
                    ChorusView(section: section, options: options, chords: song.chords)
                case .repeatChorus:
                    RepeatChorusView(section: section, options: options)
                case .tab:
                    TabView(section: section, options: options)
                case .grid:
                    GridView(section: section, options: options, chords: song.chords)
                case .comment:
                    CommentView(section: section, options: options)
                default:
                    PlainView(section: section, options: options)
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
        var label: String?
        /// Bool if the section is prominent (chorus for example)
        var prominent: Bool = false

        /// The body of the `ViewModifier`
        /// - Parameter content: The content of the section
        /// - Returns: A `View` with the wrapped section
        func body(content: Content) -> some View {
            switch options.label {
            case .inline:
                if let label {
                    VStack(alignment: .leading) {
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
                    .padding(.top)
                } else {
                    content
                        .padding(.top)
                        .frame(maxWidth: .infinity)
                }
            case .grid:
                GridRow {
                    Text(label ?? " ")
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
                                    prominent || label != nil ? Color.secondary.opacity(0.3) : Color.clear), alignment: .leading
                        )
                        .gridColumnAlignment(.leading)
                }
            }
        }
    }

    /// SwiftUI `View` for plain text
    struct PlainView: View {
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
            .frame(maxWidth: 400)
            .modifier(SectionView(options: options, label: section.label))
        }
    }

    /// SwiftUI `View` for a grid
    struct GridView: View {
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
                    }
                }
            }
            .modifier(SectionView(options: options, label: section.label))
        }
    }

    /// SwiftUI `View` for a verse
    struct VerseView: View {
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
                    PartsView(options: options, sectionID: section.id, parts: line.parts, chords: chords)
                }
            }
            .modifier(SectionView(options: options, label: section.label))
        }
    }

    /// SwiftUI `View` for a chorus
    struct ChorusView: View {
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
                    PartsView(options: options, sectionID: section.id, parts: line.parts, chords: chords)
                }
            }
            .modifier(SectionView(options: options, label: section.label ?? "Chorus", prominent: true))
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
            ProminentLabel(options: options, label: section.label ?? "Repeat Chorus", icon: "arrow.triangle.2.circlepath")
                .modifier(SectionView(options: options))
        }
    }

    /// SwiftUI `View` for a tab
    struct TabView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The display options
        let options: Song.DisplayOptions
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    Text(line.tab)
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.01)
            .monospaced()
            .modifier(SectionView(options: options, label: section.label))
        }
    }

    /// SwiftUI `View` for a comment
    struct CommentView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The display options
        let options: Song.DisplayOptions
        /// The body of the `View`
        var body: some View {
            ProminentLabel(options: options, label: section.label ?? "", icon: "bubble.right", color: .yellow)
                .italic()
                .modifier(SectionView(options: options))
        }
    }

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
                Label(label, systemImage: icon)
                    .padding(options.scale * 6)
                    .background(color.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
            } else {
                Text(label)
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
