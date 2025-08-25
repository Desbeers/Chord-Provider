//
//  Render+LyricsSection.swift
//  ChordProviderHTML
//
//  Created by Nick Berendsen on 23/08/2025.
//

import Foundation
import ChordProviderCore

public extension HtmlRender {
    static public func lyricsSection(output: inout [String], section: Song.Section, settings: HtmlSettings) {
        for line in section.lines {
            switch line.type {
            case .songLine:
                if let lineParts = line.parts {
                    parts(output: &output, parts: lineParts, settings: settings)
                }
            case .emptyLine:
                output.append("<br />")
            case .comment:
                break
                //CommentLabel(comment: line.plain, inline: true, settings: settings)
            default:
                break
            }
        }
    }
}
