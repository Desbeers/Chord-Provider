//
//  GtkRender+TextblockSection.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    struct TextblockSection: View {
        init(section: Song.Section, settings: AppSettings, maxLenght: Int) {
            self.section = section
            self.settings = settings
            self.maxLenght = maxLenght
            self.halign = Utils.getAlign(section.arguments)
            self.flush = Utils.getTextFlush(section.arguments)
        }
        
        let section: Song.Section
        let settings: AppSettings
        let maxLenght: Int
        let halign: Alignment
        let flush: Alignment
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    VStack {
                        switch line.type {
                        case .songLine:
                            let lines: [ElementWrapper] = line.plain?.wrap(by: maxLenght) ?? [ElementWrapper(content: "")]
                            ForEach(lines) { line in
                                Text(line.content)
                                    .useMarkup()
                                    .style(.textblock)
                                    .halign(flush)
                            }
                            EmptyView()
                        case .emptyLine:
                            Text(" ")
                                .style(.textblock)
                        case .comment:
                            CommentLabel(comment: line.plain ?? "Empty Comment", settings: settings)
                        default:
                            EmptyView()
                        }
                    }
                    .halign(flush)
                }
            }
            .halign(halign)
            .padding(10)
        }
    }
}
