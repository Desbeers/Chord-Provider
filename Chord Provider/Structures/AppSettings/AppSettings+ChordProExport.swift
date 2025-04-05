//
//  AppSettings+ChordProExport.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 05/04/2025.
//

import Foundation

extension AppSettings {

    func exportToChordProJSON(chords: [ChordDefinition]) -> String {

        var settings = ChordProConfig()
        settings.pdf.theme = self.style.theme

        let fonts = self.style.fonts

        for config in FontConfig.allCases {
            switch config {

            case .title:
                settings.pdf.fontconfig["\(fonts.title.fontFamily)."] = fonts.title.font
                settings.pdf.fonts["title"] = .init(
                    color: config.color(settings: self).toHex,
                    size: Int(fonts.title.size)
                )
            case .subtitle:
                settings.pdf.fontconfig["\(fonts.subtitle.fontFamily)."] = fonts.subtitle.font
                settings.pdf.fonts["subtitle"] = .init(
                    color: config.color(settings: self).toHex,
                    size: Int(fonts.subtitle.size)
                )
            case .text:
                settings.pdf.fontconfig["\(fonts.text.fontFamily)."] = fonts.text.font
                settings.pdf.fonts["text"] = .init(
                    color: config.color(settings: self).toHex,
                    size: Int(fonts.text.size)
                )
            case .chord:
                settings.pdf.fontconfig["\(fonts.chord.fontFamily)."] = fonts.chord.font
                settings.pdf.fonts["chord"] = .init(
                    color: config.color(settings: self).toHex,
                    size: Int(fonts.chord.size)
                )
            case .label:
                settings.pdf.fontconfig["\(fonts.label.fontFamily)."] = fonts.label.font
                settings.pdf.fonts["label"] = .init(
                    color: config.color(settings: self).toHex,
                    background: fonts.label.background.toHex,
                    size: Int(fonts.label.size)
                )
            case .comment:
                settings.pdf.fontconfig["\(fonts.comment.fontFamily)."] = fonts.comment.font
                settings.pdf.fonts["comment"] = .init(
                    color: config.color(settings: self).toHex,
                    background: fonts.comment.background.toHex,
                    size: Int(fonts.comment.size)
                )
            case .tag:
                break
            case .textblock:
                break
            }
        }

        settings.chords = chords.map { chord in
            Chord_Provider.ChordPro.Instrument.Chord(
                name: chord.name,
                display: chord.display,
                base: chord.baseFret,
                frets: chord.frets,
                fingers: chord.fingers,
                copy: nil
            )
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let encodedData = try encoder.encode(settings)
            return String(data: encodedData, encoding: .utf8) ?? "error"
        } catch {
            /// This should not happen
            return "error"
        }
    }
}
