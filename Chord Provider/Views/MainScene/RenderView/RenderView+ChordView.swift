//
//  Song+RenderView+ChordView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    /// Store diagrams in a memory cache for performance
    @MainActor static let diagramCache = NSCache<NSString, NSImage>()

    /// SwiftUI `View` for a chord as part of a line
    struct ChordView: View {
        /// The application settings
        let settings: AppSettings
        /// The  chord
        let chord: ChordDefinition
        /// The ID of the popover
        let popoverID: String
        /// The font for a chord
        let font: Font
        /// The color of a chord
        let color: Color
        /// Init
        init(chord: ChordDefinition, settings: AppSettings) {
            self.settings = settings
            self.chord = chord
            self.popoverID = UUID().uuidString
            self.font = settings.style.fonts.chord.swiftUIFont(scale: settings.scale.magnifier)
            switch chord.status {
            case .unknownChord, .customTransposedChord, .transposedUnknownChord:
                self.color = .red
            default:
                self.color = settings.style.fonts.chord.color
            }
        }
        /// The `popover` state
        @State private var popover: String?
        /// The body of the `View`
        var body: some View {
            switch settings.display.showInlineDiagrams {
            case true:
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
                            .frame(height: settings.scale.magnifier * 40)
                    }
                )
                .buttonStyle(.plain)
            case false:
                Text("\(chord.display) ")
                    .foregroundStyle(color)
                    .onTapGesture {
                        popover = popoverID
                    }
                    .id(popoverID)
                    .popover(item: $popover) { _ in
                        ChordDefinitionView(chord: chord, width: 140, settings: settings)
                            .background(settings.style.theme.background)
                    }
                    .onHover { hovering in
                        if hovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
                    .font(font)
            }
        }
        /// Get the diagram
        /// - Note: Diagrams are stored in a memory cache to improve performance
        func getDiagram() -> some View {
            /// Create a unique ID
            let diagramID = "\(chord.baseFret)-\(chord.frets)"
            /// Check if in cache
            if let cachedImage = RenderView.diagramCache.object(forKey: "\(diagramID)" as NSString) {
                return Image(nsImage: cachedImage).resizable()
            } else {
                var settings = settings
                settings.diagram.showFingers = false
                settings.diagram.showPlayButton = false
                settings.diagram.showNotes = false
                let renderer = ImageRenderer(
                    content:
                        ChordDefinitionView(
                            chord: chord,
                            width: 100,
                            settings: settings
                        )
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
