//
//  AppSettings+ChordProExport.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
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
                settings.pdf.fontconfig["\(fonts.title.font.familyName)."] = fonts.title.font.postScriptName
                settings.pdf.fonts["title"] = .init(
                    file: FontUtils.getTTFfont(font: fonts.title.font),
                    color: config.color(settings: self).toHex,
                    size: Int(fonts.title.size)
                )
            case .subtitle:
                settings.pdf.fontconfig["\(fonts.subtitle.font.familyName)."] = fonts.subtitle.font.postScriptName
                settings.pdf.fonts["subtitle"] = .init(
                    file: FontUtils.getTTFfont(font: fonts.subtitle.font),
                    color: config.color(settings: self).toHex,
                    size: Int(fonts.subtitle.size)
                )
            case .text:
                settings.pdf.fontconfig["\(fonts.text.font.familyName)."] = fonts.text.font.postScriptName
                settings.pdf.fonts["text"] = .init(
                    file: FontUtils.getTTFfont(font: fonts.text.font),
                    color: config.color(settings: self).toHex,
                    size: Int(fonts.text.size)
                )
            case .chord:
                settings.pdf.fontconfig["\(fonts.chord.font.familyName)."] = fonts.chord.font.postScriptName
                settings.pdf.fonts["chord"] = .init(
                    file: FontUtils.getTTFfont(font: fonts.chord.font),
                    color: config.color(settings: self).toHex,
                    size: Int(fonts.chord.size)
                )
            case .label:
                settings.pdf.fontconfig["\(fonts.label.font.familyName)."] = fonts.label.font.postScriptName
                settings.pdf.fonts["label"] = .init(
                    file: FontUtils.getTTFfont(font: fonts.label.font),
                    color: config.color(settings: self).toHex,
                    background: fonts.label.background.toHex,
                    size: Int(fonts.label.size)
                )
            case .comment:
                settings.pdf.fontconfig["\(fonts.comment.font.familyName)."] = fonts.comment.font.postScriptName
                settings.pdf.fonts["comment"] = .init(
                    file: FontUtils.getTTFfont(font: fonts.comment.font),
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
