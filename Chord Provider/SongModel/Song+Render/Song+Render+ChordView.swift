//
//  Song+Render+ChordView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension Song.Render {

    /// Store diagrams in a memory cache for performance
    static let diagramCache = NSCache<NSString, SWIFTImage>()

    /// SwiftUI `View` for a chord as part of a line
    struct ChordView: View {
        /// The display options
        let options: Song.DisplayOptions
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
            case .customTransposed, .unknown:
                Color.red
            default:
                Color.accentColor
            }
        }
        /// The `popover` state
        @State private var popover: String?
        /// The 'hover' state
        @State private var hover: Bool = false
        /// The body of the `View`
        var body: some View {
            switch options.chords {
            case .asName:
                Text(chord.displayName(options: .init()))
                    .padding(.trailing)
                    .foregroundColor(color)
                    .onTapGesture {
                        popover = popoverID
                    }
                    .id(popoverID)
                    .popover(item: $popover) { _ in
                        ChordDiagramView(chord: chord, width: 140)
                            .padding()
                    }
#if os(macOS)
                    .onHover { hovering in
                        if hovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
#endif
            case .asDiagram:
                Button(
                    action: {
                        if chord.status != .unknown {
                            chord.play(instrument: options.midiInstrument)
                        }
                    },
                    label: {
                        getDiagram()
                            .offset(x: -4)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: options.scale * 40)
                    }
                )
                .buttonStyle(.plain)
            }
        }
        /// Get the diagram
        /// - Note: Diagrams are stored in a memory cache to improve performance
        @MainActor func getDiagram() -> some View {
            /// Check if in cache
            if let cachedImage = Song.Render.diagramCache.object(forKey: "\(chord.id.uuidString)\(colorScheme)" as NSString) {
                return Image(swiftImage: cachedImage).resizable()
            } else {
                let primaryColor: Color = colorScheme == .dark ? .white : .black
                let secondaryColor: Color = colorScheme == .dark ? .black : .white
                let renderer = ImageRenderer(
                    content:
                        ChordDefinitionView(chord: chord, width: 100, options: .init())
                        .foregroundStyle(primaryColor, secondaryColor)
                )
                renderer.scale = 2
#if os(macOS)
                let image = renderer.nsImage
#else
                let image = renderer.uiImage
#endif
                guard let image else {
                    return Image(systemName: "questionmark.bubble")
                }
                /// Store in the cache
                Song.Render.diagramCache.setObject(image, forKey: "\(chord.id.uuidString)\(colorScheme)" as NSString)
                return Image(swiftImage: image).resizable()
            }
        }
    }
}
