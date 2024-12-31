//
//  Song+RenderView+ChordView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    /// Store diagrams in a memory cache for performance
    static let diagramCache = NSCache<NSString, NSImage>()

    /// SwiftUI `View` for a chord as part of a line
    struct ChordView: View {

        /// The display options
        let settings: AppSettings.Song
        /// The ID of the section
        let sectionID: Int
        /// The ID of the part
        let partID: Int
        /// The  chord
        let chord: ChordDefinition
        /// The current color scheme
        @Environment(\.colorScheme) var colorScheme
        /// The calculated ID of this `View`
        var popoverID: String {
            "\(sectionID)-\(partID)-\(chord.name)"
        }
        /// The color of a chord
        var color: Color {
            switch chord.status {
            case .unknownChord, .customTransposedChord, .transposedUnknownChord:
                Color.red
            default:
                Color.accentColor
            }
        }
        /// The `popover` state
        @State private var popover: String?
        /// The body of the `View`
        var body: some View {
            switch settings.display.chords {
            case .asName:
                Text("\(chord.display) ")
                    .foregroundStyle(color)
                    .onTapGesture {
                        popover = popoverID
                    }
                    .id(popoverID)
                    .popover(item: $popover) { _ in
                        ChordDiagramView(chord: chord, width: 140)
                            .padding()
                    }
                    .onHover { hovering in
                        if hovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
            case .asDiagram:
                Button(
                    action: {
                        if chord.status != .unknownChord {
                            chord.play(instrument: settings.diagram.midiInstrument)
                        }
                    },
                    label: {
                        getDiagram()
                            .offset(x: -4)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: settings.display.scale * 40)
                    }
                )
                .buttonStyle(.plain)
            }
        }
        /// Get the diagram
        /// - Note: Diagrams are stored in a memory cache to improve performance
        func getDiagram() -> some View {
            /// Create a unique ID
            let diagramID = "\(chord.baseFret)-\(chord.frets)-\(colorScheme)"
            /// Check if in cache
            if let cachedImage = RenderView.diagramCache.object(forKey: "\(diagramID)" as NSString) {
                return Image(nsImage: cachedImage).resizable()
            } else {
                let primaryColor: Color = colorScheme == .dark ? .white : .black
                let secondaryColor: Color = colorScheme == .dark ? .black : .white
                var settings = settings
                settings.diagram.showFingers = false
                settings.diagram.showPlayButton = false
                let renderer = ImageRenderer(
                    content:
                        ChordDefinitionView(
                            chord: chord,
                            width: 100,
                            settings: settings
                        )
                        .foregroundStyle(primaryColor, secondaryColor)
                )
                renderer.scale = 2
                let image = renderer.nsImage
                guard let image else {
                    return Image(systemName: "questionmark.bubble")
                }
                /// Store in the cache
                RenderView.diagramCache.setObject(image, forKey: "\(diagramID)" as NSString)
                return Image(nsImage: image).resizable()
            }
        }
    }
}
