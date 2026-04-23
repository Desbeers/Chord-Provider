//
//  GtkRender+TextblockSection.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a textblock section
    struct TextblockSection: View {
        /// Init the `View`
        /// - Parameters:
        ///   - section: The current section
        ///   - maxLenght: The maximum length of a single line
        ///   - coreSettings: The core settings
        init(section: Song.Section, maxLenght: Int, coreSetting: ChordProviderSettings) {
            self.section = section
            self.maxLenght = maxLenght
            self.coreSettings = coreSetting
            self.halign = Utils.getTextAlignment(section.arguments)
            self.flush = Utils.getTextFlush(section.arguments)
        }
        /// The current section of the song
        let section: Song.Section
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The maximum length of a single line
        let maxLenght: Int
        /// The horizontal alignment
        let halign: Alignment
        /// The alignment of multi-lines
        let flush: Alignment
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    VStack {
                        switch line.type {
                        case .songLine:
                            let lines = line.wholeTextWithMarkup(split: maxLenght).toElementWrapper
                            ForEach(lines) { line in
                                Text(line.content)
                                    .useMarkup()
                                    .style(.sectionTextblock)
                                    .halign(flush)
                            }
                        case .emptyLine:
                            EmptyLine()
                        case .comment:
                            CommentLabel(line: line, maxLenght: maxLenght)
                        case .chordDiagram:
                            ChordDiagram(line: line, coreSettings: coreSettings)
                        default:
                            Views.Empty()
                        }
                    }
                    .halign(flush)
                }
            }
            .halign(halign)
            .padding()
        }
    }
}
