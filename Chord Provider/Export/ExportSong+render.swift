//
//  ExportSong+render.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension ExportSong {

    /// Render the header of the song
    /// - Parameter song: The song
    /// - Returns: The header as CGImage
    @MainActor
    static func renderHeader(song: Song) -> CGImage? {
        let renderer = ImageRenderer(
            content:
                VStack {
                    Text(song.title ?? "Title")
                        .font(.largeTitle)
                    Text(song.artist ?? "Artist")
                        .font(.title2)
                        .foregroundColor(Color.gray)
                        .padding(.bottom)
                    HeaderView.Details(song: song)
                }
                .frame(width: pageWidth, alignment: .center)
                .preferredColorScheme(.light)
                .background(.white)
        )
        renderer.scale = rendererScale
        return renderer.cgImage
    }

    /// Render the chords of the song
    /// - Parameter song: The song
    /// - Returns: The header as CGImage
    @MainActor
    static func renderChords(song: Song) -> CGImage? {
        /// Size of the chord diagrams
        let diagramOptions = ChordDefinition.DisplayOptions(
            showName: true,
            showNotes: true,
            showPlayButton: false,
            rootDisplay: .symbol,
            qualityDisplay: .symbolized,
            showFingers: true,
            mirrorDiagram: false
        )
        /// The grid items
        let gridItems = Array(repeating: GridItem(.fixed(100), spacing: 0), count: 6)
        /// Render the chords
        let renderer = ImageRenderer(
            content:
                LazyVGrid(
                    columns: gridItems,
                    alignment: .center,
                    spacing: 4
                ) {
                    ForEach(song.chords.sorted(using: KeyPathComparator(\.name))) { chord in
                        ChordDefinitionView(chord: chord, width: 100, options: diagramOptions)
                            .foregroundStyle(.black, .white)
                            .frame(height: 150, alignment: .top)
                    }
                }
                .padding()
                .frame(width: pageWidth, alignment: .center)
                .preferredColorScheme(.light)
                .background(.white)
        )
        renderer.scale = rendererScale
        return renderer.cgImage
    }

    /// Render all the parts of the song
    /// - Parameter song: The song
    /// - Returns: An array of `CGImage`
    @MainActor
    static func renderParts(song: Song) -> [CGImage] {
        var parts: [CGImage] = []
        var part: CGImage?
        for section in song.sections {
            switch section.type {
            case .verse, .bridge:
                part = renderPart(view: Song.Render.VerseView(section: section, chords: song.chords))
            case .chorus:
                part = renderPart(view: Song.Render.ChorusView(section: section, chords: song.chords))
            case .repeatChorus:
                part = renderPart(view: Song.Render.RepeatChorusView(section: section))
            case .tab:
                part = renderPart(view: Song.Render.TabView(section: section))
            case .grid:
                part = renderPart(view: Song.Render.GridView(section: section, chords: song.chords))
            case .comment:
                part = renderPart(view: Song.Render.CommentView(section: section))
            default:
                part = renderPart(view: Song.Render.PlainView(section: section))
            }
            if let part {
                parts.append(part)
            }
        }
        return parts

        /// Helper function to render a part
        /// - Parameter view: The SwiftUI View to render
        /// - Returns: A `CGImage` of the View
        func renderPart<T: View>(view: T) -> CGImage? {
            let renderer = ImageRenderer(
                content:
                    VStack {
                        Grid(alignment: .topTrailing, verticalSpacing: 20) {
                            view
                        }
                        .padding()
                    }
                    .frame(width: pageWidth, alignment: .leading)
                    .accentColor(Color.gray)
                    .background(.white)
                    .font(.system(size: 14))
            )
            renderer.scale = rendererScale
            return renderer.cgImage
        }
    }
}
