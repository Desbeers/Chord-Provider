//
//  SongRenderView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// Convert a ``Song`` Struct into a SwiftUI View
struct SongRenderView: View {
    let song: Song
    let scale: CGFloat
    /// The body of the View
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
        .frame(maxWidth: .infinity, alignment: .center)
        .font(.system(size: 14 * scale))
    }
}

extension SongRenderView {
    
    /// Wrapper around a section
    struct SectionView: ViewModifier {
        let section: Song.Section
        let scale: Double
        var label: String?
        var prominent: Bool = false
        func body(content: Content) -> some View {
            GridRow {
                if let label {
                    Text(label)
                        .padding(.all, prominent ? 10 : 0)
                        .background(prominent ? Color.accentColor.opacity(0.3) : Color.clear, in: RoundedRectangle(cornerRadius: 4))
                        .gridColumnAlignment(.trailing)
                        .layoutPriority(1)
                } else {
                    Color.clear
                        .gridCellUnsizedAxes([.horizontal, .vertical])
                }
                content
                    .padding(.leading)
                    .overlay(
                        Rectangle()
                            .frame(width: 1, height: nil, alignment: .leading)
                            .foregroundColor(prominent || label != nil ? Color.secondary.opacity(0.3) : Color.clear), alignment: .leading)
                    .gridColumnAlignment(.leading)
                    .layoutPriority(1)
            }
        }
    }
    
    struct PlainView: View {
        let section: Song.Section
        let scale: Double
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
    
    struct GridView: View {
        let section: Song.Section
        let scale: Double
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
    
    struct VerseView: View {
        let section: Song.Section
        let scale: Double
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    PartsView(parts: line.parts)
                }
            }
            .modifier(SectionView(section: section, scale: scale, label: section.label))
        }
    }
    
    struct ChorusView: View {
        let section: Song.Section
        let scale: Double
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    PartsView(parts: line.parts)
                }
            }
            .modifier(SectionView(section: section, scale: scale, label: section.label ?? "Chorus", prominent: true))
        }
    }
    
    struct RepeatChorusView: View {
        let section: Song.Section
        let scale: Double
        var body: some View {
            Label(section.label ?? "Repeat Chorus", systemImage: "arrow.triangle.2.circlepath")
                .padding(.trailing)
                .padding(4 * scale)
                .background(Color.accentColor.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
                .font(.system(size: 12 * scale))
                .modifier(SectionView(section: section, scale: scale))
        }
    }
    
    struct TabView: View {
        let section: Song.Section
        let scale: Double
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
    
    struct CommentView: View {
        let section: Song.Section
        let scale: Double
        var body: some View {
            Label(section.label ?? "", systemImage: "bubble.right")
                .padding(4 * scale)
                .background(Color.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
                .font(.system(size: 10 * scale))
                .italic()
                .modifier(SectionView(section: section, scale: scale))
        }
    }
    
    struct PartsView: View {
        let parts: [Song.Section.Line.Part]
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
                    }
                }
            }
        }
    }
}
