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
        init(section: Song.Section, settings: AppSettings, maxLenght: Int) {
            self.section = section
            self.settings = settings
            self.maxLenght = maxLenght
            self.halign = Utils.getTextAlignment(section.arguments)
            self.flush = Utils.getTextFlush(section.arguments)
        }
        /// The current section of the song
        let section: Song.Section
        /// The settings of the application
        let settings: AppSettings
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
                            let lines: [String.ElementWrapper] = line.plain?.wrap(by: maxLenght) ?? [String.ElementWrapper(content: "")]
                            ForEach(lines) { line in
                                Text(line.content)
                                    .useMarkup()
                                    .style(.sectionTextblock)
                                    .halign(flush)
                            }
                        case .emptyLine:
                            EmptyLine()
                        case .comment:
                            CommentLabel(comment: line.plain ?? "Empty Comment", settings: settings)
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
