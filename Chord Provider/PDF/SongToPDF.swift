//
//  SongToPDF.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

enum SongToPDF {
    // Just a placeholder
}

extension SongToPDF {


    /// Get all the PDF elements for a song
    /// - Parameters:
    ///   - song: The ``Song``
    ///   - options: The display options
    /// - Returns: All the PDF elements in an array
    static func getSongElements(
        song: Song,
        options: ChordDefinition.DisplayOptions,
        counter: PdfBuild.TextPageCounter
    ) -> [PdfElement] {
        var items: [PdfElement] = []

        items.append(PdfBuild.SongSection(song: song, counter: counter))

        items.append(PdfBuild.Text("\(song.title ?? "No Title")", attributes: .songTitle))
        items.append(PdfBuild.Text("\(song.artist ?? "Unknown Artist")", attributes: .songArtist))
        items.append(PdfBuild.Spacer(10))
        items.append(PdfBuild.SongDetails(song: song))
        items.append(PdfBuild.Spacer(10))
        items.append(PdfBuild.Chords(chords: song.chords, options: options))
        items.append(PdfBuild.Spacer(10))
        /// Add all the sections
        for section in song.sections {
            switch section.type {
            case .chorus:
                items.append(SongToPDF.lyricsSection(section: section, chords: song.chords))
            case .repeatChorus:
                items.append(SongToPDF.repeatChorusSection(section: section, chords: song.chords))
            case .verse:
                items.append(SongToPDF.lyricsSection(section: section, chords: song.chords))
            case .bridge:
                items.append(SongToPDF.lyricsSection(section: section, chords: song.chords))
            case .comment:
                items.append(SongToPDF.commentSection(section: section, chords: song.chords))
            case .tab:
                items.append(SongToPDF.tabSection(section: section, chords: song.chords))
            case .grid:
                items.append(SongToPDF.gridSection(section: section, chords: song.chords))
            case .textblock:
                items.append(SongToPDF.textblockSection(section: section, chords: song.chords))
            case .none:
                items.append(SongToPDF.plainSection(section: section, chords: song.chords))
            case .strum:
                items.append(SongToPDF.strumSection(section: section, chords: song.chords))
            }
            items.append(PdfBuild.Spacer(10))
        }
        /// Return the items
        return items
    }

    static func renderPDF(
        song: Song,
        options: ChordDefinition.DisplayOptions
    ) -> (pdf: Data, toc: [PdfBuild.SongInfo]) {

        let pdfInfo = PdfBuild.DocumentInfo(
            title: song.title ?? "No title",
            author: song.artist ?? "Unknown artist"
        )

        let builder = PdfBuild.Builder(info: pdfInfo)

        let counter = PdfBuild.TextPageCounter(pageNumber: 0, attributes: .pageCounter)

        builder.pageCounter = counter

        // MARK: Add PDF elements

        builder.items = [
            PdfBuild.PageHeader(
                top: [],
                bottom: [
                    counter
                ]
            )
        ]
        builder.items.append(contentsOf: getSongElements(song: song, options: options, counter: counter))

        /// Generate the PDF
        let pdf = builder.generatePdf() as Data

        /// Return the PDF and the list of songs sorted by page
        return (pdf, Array(counter.songs).sorted(using: KeyPathComparator(\.page)))
    }
}

extension SongToPDF {

    // MARK: Lyics Section (verse, chord or bridge)

    static func lyricsSection(section: Song.Section, chords: [ChordDefinition]) -> PdfBuild.Section {
        PdfBuild.Section(
            columns: [.fixed(width: 100), .fixed(width: 20), .flexible],
            items: [
                PdfBuild.Label(
                    leading: nil,
                    label: NSAttributedString(string: section.label, attributes: .sectionLabel),
                    color: section.type == .chorus ? .gray.withAlphaComponent(0.3) : .clear,
                    alignment: .right
                ),
                PdfBuild.Divider(direction: .vertical),
                PdfBuild.LyricsSection(section, chords: chords)
            ]
        )
    }
}

extension SongToPDF {

    // MARK: Tab Section

    static func tabSection(section: Song.Section, chords: [ChordDefinition]) -> PdfBuild.Section {
        PdfBuild.Section(
            columns: [.fixed(width: 100), .fixed(width: 20), .flexible],
            items: [
                PdfBuild.Label(
                    leading: nil,
                    label: NSAttributedString(string: section.label, attributes: .sectionLabel),
                    color: .clear,
                    alignment: .right
                ),
                PdfBuild.Divider(direction: .vertical),
                PdfBuild.TabSection(section)
            ]
        )
    }
}

extension SongToPDF {

    // MARK: Grid Section

    static func gridSection(section: Song.Section, chords: [ChordDefinition]) -> PdfBuild.Section {
        PdfBuild.Section(
            columns: [.fixed(width: 100), .fixed(width: 20), .flexible],
            items: [
                PdfBuild.Label(
                    leading: nil,
                    label: NSAttributedString(string: section.label, attributes: .sectionLabel),
                    color: .clear,
                    alignment: .right
                ),
                PdfBuild.Divider(direction: .vertical),
                PdfBuild.GridSection(section, chords: chords)
            ]
        )
    }
}

extension SongToPDF {

    // MARK: Strum Section

    static func strumSection(section: Song.Section, chords: [ChordDefinition]) -> PdfBuild.Section {
        let label = NSAttributedString(string: section.label, attributes: .sectionLabel)
        return PdfBuild.Section(
            columns: [.fixed(width: 100), .fixed(width: 20), .flexible],
            items: [
                PdfBuild.Label(
                    leading: nil,
                    label: label,
                    color: .clear,
                    alignment: .right
                ),
                PdfBuild.Divider(direction: .vertical),
                PdfBuild.StrumSection(section)
            ]
        )
    }
}

extension SongToPDF {

    // MARK: Textblock Section

    static func textblockSection(section: Song.Section, chords: [ChordDefinition]) -> PdfBuild.Section {
        PdfBuild.Section(
            columns: [.fixed(width: 100), .fixed(width: 20), .flexible],
            items: [
                PdfBuild.Label(
                    leading: nil,
                    label: NSAttributedString(string: section.label, attributes: .sectionLabel),
                    color: .clear,
                    alignment: .right
                ),
                PdfBuild.Divider(direction: .vertical),
                PdfBuild.TextblockSection(section)
            ]
        )
    }
}

extension SongToPDF {

    // MARK: Plain Section

    static func plainSection(section: Song.Section, chords: [ChordDefinition]) -> PdfBuild.Section {
        PdfBuild.Section(
            columns: [.fixed(width: 110), .flexible],
            items: [
                PdfBuild.Spacer(),
                PdfBuild.PlainSection(section)
            ]
        )
    }
}

extension SongToPDF {

    // MARK: Comment Section

    static func commentSection(section: Song.Section, chords: [ChordDefinition]) -> PdfBuild.Section {
        PdfBuild.Section(
            columns: [.fixed(width: 110), .flexible],
            items: [
                PdfBuild.Spacer(),
                PdfBuild.Comment(section.lines.first?.comment ?? "Empty comment")
            ]
        )
    }
}

extension SongToPDF {

    // MARK: Repeat Chorus Section

    static func repeatChorusSection(section: Song.Section, chords: [ChordDefinition]) -> PdfBuild.Section {

        let leading = NSAttributedString(string: "􀊯", attributes: .sectionLabel)
        let label = NSAttributedString(string: section.label, attributes: .sectionLabel)

        return PdfBuild.Section(
            columns: [.fixed(width: 110), .flexible],
            items: [
                PdfBuild.Spacer(),
                PdfBuild.Label(
                    leading: leading,
                    label: label,
                    color: .gray.withAlphaComponent(0.3),
                    alignment: .left
                )
            ]
        )
    }
}
