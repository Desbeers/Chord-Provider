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
        /// The body of the `View`
        var body: some View {
            Grid(alignment: .topTrailing, verticalSpacing: 20 * scale) {
                ForEach(song.sections) { section in
                    switch section.type {
                    case .verse:
                        VerseView(section: section, scale: scale)
                    case .chorus:
                        ChorusView(section: section, scale: scale)
                    case .bridge:
                        VerseView(section: section, scale: scale)
                    case .repeatChorus:
                        RepeatChorusView(section: section, scale: scale)
                    case .tab:
                        TabView(section: section, scale: scale)
                    case .grid:
                        GridView(section: section, scale: scale)
                    case .comment:
                        CommentView(section: section, scale: scale)
                    default:
                        PlainView(section: section, scale: scale)
                    }
                }
            }
            .padding()
            .font(.system(size: 14 * scale))
        }
    }
}

extension Song.Render {

    /// Wrapper around a section
    struct SectionView: ViewModifier {
        /// The `section` of the song
        let section: Song.Section
        /// The scale factor of the `View`
        let scale: Double
        /// The optional label
        var label: String?
        /// Bool if the section is prominent (chorus for example)
        var prominent: Bool = false

        /// The body of the `ViewModifier`
        /// - Parameter content: The content of the section
        /// - Returns: A `View` with the wrapped section
        func body(content: Content) -> some View {
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
                            .foregroundColor(prominent || label != nil ? Color.secondary.opacity(0.3) : Color.clear), alignment: .leading)
                    .gridColumnAlignment(.leading)
            }
        }
    }

    /// SwiftUI `View` for plain text
    struct PlainView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The scale factor of the `View`
        let scale: Double
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    ForEach(line.parts) { part in
                        Text(part.text)
                    }
                }
            }
            .modifier(SectionView(section: section, scale: scale, label: section.label))
        }
    }

    /// SwiftUI `View` for a grid
    struct GridView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The scale factor of the `View`
        let scale: Double
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
            .modifier(SectionView(section: section, scale: scale, label: section.label))
        }
    }

    /// SwiftUI `View` for a verse
    struct VerseView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The scale factor of the `View`
        let scale: Double
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    PartsView(parts: line.parts)
                }
            }
            .modifier(SectionView(section: section, scale: scale, label: section.label))
        }
    }

    /// SwiftUI `View` for a chorus
    struct ChorusView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The scale factor of the `View`
        let scale: Double
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    PartsView(parts: line.parts)
                }
            }
            .modifier(SectionView(section: section, scale: scale, label: section.label ?? "Chorus", prominent: true))
        }
    }

    /// SwiftUI `View` for a chorus repeat
    struct RepeatChorusView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The scale factor of the `View`
        let scale: Double
        /// The body of the `View`
        var body: some View {
            Label(section.label ?? "Repeat Chorus", systemImage: "arrow.triangle.2.circlepath")
                .padding(.trailing)
                .padding(4 * scale)
                .background(Color.accentColor.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
                .font(.system(size: 12 * scale))
                .modifier(SectionView(section: section, scale: scale))
        }
    }

    /// SwiftUI `View` for a tab
    struct TabView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The scale factor of the `View`
        let scale: Double
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    Text(line.tab)
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .monospaced()
            .modifier(SectionView(section: section, scale: scale, label: section.label))
        }
    }

    /// SwiftUI `View` for a comment
    struct CommentView: View {
        /// The `section` of the song
        let section: Song.Section
        /// The scale factor of the `View`
        let scale: Double
        /// The body of the `View`
        var body: some View {
            Label(section.label ?? "", systemImage: "bubble.right")
                .padding(4 * scale)
                .background(Color.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
                .font(.system(size: 10 * scale))
                .italic()
                .modifier(SectionView(section: section, scale: scale))
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
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
    }
}
