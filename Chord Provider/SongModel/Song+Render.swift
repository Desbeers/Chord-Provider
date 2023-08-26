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
                case .verse:
                    VerseView(section: section, style: style)
                case .chorus:
                    ChorusView(section: section, style: style)
                case .bridge:
                    VerseView(section: section, style: style)
                case .repeatChorus:
                    RepeatChorusView(section: section, style: style)
                case .tab:
                    TabView(section: section, style: style)
                case .grid:
                    GridView(section: section, style: style)
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
                    .font(.title2)
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
                        .font(.title2)
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
                                    if let chord = part.chord {
                                        Text(chord)
                                            .foregroundColor(.accentColor)
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
        /// The style of the `View`
        var style: Song.Style = .asGrid
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    PartsView(parts: line.parts)
                }
            }
            .modifier(SectionView(style: style, label: section.label))
        }
    }

    /// SwiftUI `View` for a chorus
    struct ChorusView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The style of the `View`
        var style: Song.Style = .asGrid
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    PartsView(parts: line.parts)
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
            ProminentLabel(label: section.label ?? "", icon: "bubble.right")
                .italic()
                .modifier(SectionView(style: style))
        }
    }

    /// SwiftUI `View` for parts of a line
    struct PartsView: View {
        /// The `parts` of a `line`
        let parts: [Song.Section.Line.Part]
        /// The body of the `View`
        var body: some View {
            HStack(spacing: 0) {
                ForEach(parts) { part in
                    VStack(alignment: .leading) {
                        if let chord = part.chord {
                            Text(chord)
                                .padding(.trailing)
                                .foregroundColor(.accentColor)
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

    struct ProminentLabel: View {
        let label: String
        var icon: String?
        var body: some View {
            if let icon {
                Label(label, systemImage: icon)
                    .padding(10)
                    .background(Color.accentColor.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
            } else {
                Text(label)
                    .padding(10)
                    .background(Color.accentColor.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
            }
        }
    }
}
