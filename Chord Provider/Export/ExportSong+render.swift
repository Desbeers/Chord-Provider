//
//  ExportSong+render.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

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
                        .foregroundColor(Color("AccentColor"))
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
        /// Size of the chord diagram
        var frame: CGRect {
            var width = Int((pageWidth * 2.0) / Double(song.chords.count))
            width = width > Int(pageWidth / 4.0) ? Int(pageWidth / 4.0) : width
            let height = Int(Double(width) * 1.5)
            return CGRect(x: 0, y: 0, width: width, height: height)
        }
        /// Render the chords
        let renderer = ImageRenderer(
            content:
                HStack {
                    ForEach(song.chords.sorted(using: KeyPathComparator(\.name))) { chord in
                        VStack {
                            Text(chord.display)
                                .foregroundColor(Color("AccentColor"))
                                .font(.caption)
                            let layer = chord.chordPosition.chordLayer(
                                rect: frame,
                                showFingers: false,
                                chordName: .init(show: false)
                            )
                            if let image = layer.image() {
                                Image(swiftImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: frame.width / 3)
                            }
                        }
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
            case .verse:
                part = renderPart(view: Song.Render.VerseView(section: section))
            case .chorus:
                part = renderPart(view: Song.Render.ChorusView(section: section))
            case .bridge:
                part = renderPart(view: Song.Render.VerseView(section: section))
            case .repeatChorus:
                part = renderPart(view: Song.Render.RepeatChorusView(section: section))
            case .tab:
                part = renderPart(view: Song.Render.TabView(section: section))
            case .grid:
                part = renderPart(view: Song.Render.GridView(section: section))
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
                    .accentColor(Color("AccentColor"))
                    .background(.white)
                    .font(.system(size: 14))
            )
            renderer.scale = rendererScale
            return renderer.cgImage
        }
    }
}
