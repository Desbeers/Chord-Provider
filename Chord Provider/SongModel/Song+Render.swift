//
//  Song+Render.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension Song {

    /// Render a ``Song`` struct into a SwiftUI View
    struct Render: View {
        /// The ``Song``
        let song: Song
        /// The scale factor of the `View`
        let scale: CGFloat
        /// The style of the `View`
        var style: Song.Style = .asGrid
        /// The body of the `View`
        var body: some View {
            VStack {
                switch style {
                case .asList:
                    VStack(alignment: .leading) {
                        sections
                    }
                case .asGrid:
                    Grid(alignment: .topTrailing, verticalSpacing: 20 * scale) {
                        sections
                    }
                }
            }

            .padding()
            .font(.system(size: 14 * scale))
        }

        /// The sections of the `View`
        var sections: some View {
            ForEach(song.sections) { section in
                switch section.type {
                case .verse, .bridge:
                    VerseView(section: section, chords: song.chords, style: style)
                case .chorus:
                    ChorusView(section: section, chords: song.chords, style: style)
                case .repeatChorus:
                    RepeatChorusView(section: section, style: style)
                case .tab:
                    TabView(section: section, style: style)
                case .grid:
                    GridView(section: section, chords: song.chords, style: style)
                case .comment:
                    CommentView(section: section, style: style)
                default:
                    PlainView(section: section, style: style)
                }
            }
        }
    }
}

extension Song.Render {

    /// Wrapper around a section
    struct SectionView: ViewModifier {
        /// The style
        let style: Song.Style
        /// The optional label
        var label: String?
        /// Bool if the section is prominent (chorus for example)
        var prominent: Bool = false

        /// The body of the `ViewModifier`
        /// - Parameter content: The content of the section
        /// - Returns: A `View` with the wrapped section
        func body(content: Content) -> some View {

            switch style {
            case .asList:
                if let label {
                    VStack {
                        switch prominent {
                        case true:
                            ProminentLabel(label: label)
                        case false:
                            Text(label)
                        }
                    }
                    .font(.title3)
                    .padding(.top)
                    Divider()
                    content
                        .padding(.leading)
                } else {
                    content
                        .padding(.top)
                        .frame(maxWidth: .infinity)
                }
            case .asGrid:
                GridRow {
                    Text(label ?? " ")
                        .padding(.all, prominent ? 10 : 0)
                        .background(prominent ? Color.accentColor.opacity(0.3) : Color.clear, in: RoundedRectangle(cornerRadius: 4))
                        .frame(minWidth: 100, alignment: .trailing)
                        .font(.title3)
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
        /// The style of the `View`
        var style: Song.Style = .asGrid
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
            .modifier(SectionView(style: style, label: section.label))
        }
    }

    /// SwiftUI `View` for a grid
    struct GridView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The chords of the song
        let chords: [Song.Chord]
        /// The style of the `View`
        var style: Song.Style = .asGrid
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
                                        ChordView(sectionID: section.id, partID: part.id, chord: chord)
                                    } else {
                                        Text(part.text)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .modifier(SectionView(style: style, label: section.label))
        }
    }

    /// SwiftUI `View` for a verse
    struct VerseView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The chords of the song
        let chords: [Song.Chord]
        /// The style of the `View`
        var style: Song.Style = .asGrid
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    PartsView(sectionID: section.id, parts: line.parts, chords: chords)
                }
            }
            .modifier(SectionView(style: style, label: section.label))
        }
    }

    /// SwiftUI `View` for a chorus
    struct ChorusView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The chords of the song
        let chords: [Song.Chord]
        /// The style of the `View`
        var style: Song.Style = .asGrid
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    PartsView(sectionID: section.id, parts: line.parts, chords: chords)
                }
            }
            .modifier(SectionView(style: style, label: section.label ?? "Chorus", prominent: true))
        }
    }

    /// SwiftUI `View` for a chorus repeat
    struct RepeatChorusView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The style of the `View`
        var style: Song.Style = .asGrid
        /// The body of the `View`
        var body: some View {
            ProminentLabel(label: section.label ?? "Repeat Chorus", icon: "arrow.triangle.2.circlepath")
                .modifier(SectionView(style: style))
        }
    }

    /// SwiftUI `View` for a tab
    struct TabView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The style of the `View`
        var style: Song.Style = .asGrid
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
            .modifier(SectionView(style: style, label: section.label))
        }
    }

    /// SwiftUI `View` for a comment
    struct CommentView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The style of the `View`
        var style: Song.Style = .asGrid
        /// The body of the `View`
        var body: some View {
            ProminentLabel(label: section.label ?? "", icon: "bubble.right", color: .yellow)
                .italic()
                .modifier(SectionView(style: style))
        }
    }

    /// SwiftUI `View` for parts of a line
    struct PartsView: View {
        /// The ID of the section
        let sectionID: Int
        /// The `parts` of a `line`
        let parts: [Song.Section.Line.Part]
        /// The chords of the song
        let chords: [Song.Chord]
        /// The body of the `View`
        var body: some View {
            HStack(spacing: 0) {
                ForEach(parts) { part in
                    VStack(alignment: .leading) {
                        if let chord = chords.first(where: { $0.id == part.chord }) {
                            ChordView(sectionID: sectionID, partID: part.id, chord: chord)
                        } else {
                            /// Fill the space
                            Text(" ")
                        }
                        Text(part.text)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }

    /// SwiftUI `View` for a chord as part of a line
    struct ChordView: View {
        /// The ID of the section
        let sectionID: Int
        /// The ID of the part
        let partID: Int
        /// The  chord
        let chord: Song.Chord
        /// The calculated ID of this `View`
        var popoverID: String {
            "\(sectionID)-\(partID)-\(chord.name)"
        }
        var color: Color {
            switch chord.status {
            case .customTransposed:
                Color.red
            default:
                Color.accentColor
            }
        }
        @State private var popover: String?
        @State private var hover: Bool = false
        /// The body of the `View`
        var body: some View {
            Text(chord.display)
                .padding(.trailing)
                .foregroundColor(color)
                .onTapGesture {
                    popover = popoverID
                }
                .id(popoverID)
                .popover(item: $popover) { _ in
                    ChordDiagramView(chord: chord, playButton: true)
                        .padding()
                }
                .onHover { hovering in
                    hover = hovering
                }
                .scaleEffect(hover ? 1.4 : 1, anchor: .center)
                .animation(.default, value: hover)
        }
    }

    struct ProminentLabel: View {
        let label: String
        var icon: String?
        var color: Color = .accentColor
        var body: some View {
            if let icon {
                Label(label, systemImage: icon)
                    .padding(10)
                    .background(color.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
            } else {
                Text(label)
                    .padding(10)
                    .background(color.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
            }
        }
    }
}

/// Make a String identifiable
extension String: Identifiable {

    // swiftlint:disable type_name
    public typealias ID = Int
    public var id: Int {
        return hash
    }
    // swiftlint:enable type_name
}
