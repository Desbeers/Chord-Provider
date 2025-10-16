//
//  Markup+Font.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Markup {

    enum Font {
        case title
        case subtitle
        case standard
        case chord
        case comment
        case tab
        case grid
        case sectionHeader
        case repeatChorus

        static let base: Double = 12.5

        func style(zoom: Double) -> String {
            switch self {
            case .standard:
                Pango.font(Markup.Font.base * zoom)
            case .chord:
                Markup.Font.standard.style(zoom: zoom) + Pango.color(HexColor.chord) + Pango.bold.rawValue
            case .comment:
                Markup.Font.standard.style(zoom: zoom) + Pango.italic.rawValue + Pango.color(HexColor.comment) + Pango.bold.rawValue
            case .tab:
                Markup.Font.standard.style(zoom: zoom) + Pango.monospace.rawValue
            case .grid:
                Markup.Font.chord.style(zoom: zoom)
            case .sectionHeader:
                Pango.font(self.size(zoom: zoom)) + Pango.bold.rawValue
            case .title:
                Pango.font(self.size(zoom: zoom)) + Pango.bold.rawValue
            case .subtitle:
                Pango.font(self.size(zoom: zoom))
            case .repeatChorus:
                Markup.Font.sectionHeader.style(zoom: zoom) + Pango.italic.rawValue
            }
        }

        func size(zoom: Double) -> Double {
            switch self {
            case .standard, .chord, .comment, .tab, .grid:
                Markup.Font.base * zoom
            case .sectionHeader, .subtitle, .repeatChorus:
                Markup.Font.base * zoom * 1.2
            case .title:
                Markup.Font.base * zoom * 1.4
            }
        }
    }
}
