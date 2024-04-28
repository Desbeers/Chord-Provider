//
//  SongExport.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

enum SongExport {
    // Just a placeholder
}

extension SongExport {

    /// Export a single song to PDF
    /// - Parameters:
    ///   - song: The ``Song`` to export
    ///   - options: The chord display options
    /// - Returns: The song as PDF `Data` and the TOC as a `TOCInfo` array
    static func export(
        song: Song,
        options: ChordDefinition.DisplayOptions
    ) throws -> (pdf: Data, toc: [PDFBuild.TOCInfo]) {
        let pdfInfo = PDFBuild.DocumentInfo(
            title: song.title ?? "No title",
            author: song.artist ?? "Unknown artist"
        )
        let builder = PDFBuild.Builder(info: pdfInfo)
        let counter = PDFBuild.PageCounter(firstPage: 0, attributes: .footer + .alignment(.center))
        builder.pageCounter = counter

        // MARK: Add PDF elements

        builder.elements = [
            PDFBuild.PageHeaderFooter(
                header: [],
                footer: [
                    counter
                ]
            )
        ]
        builder.elements.append(contentsOf: getSongElements(song: song, options: options, counter: counter))

        /// Generate the PDF
        let pdf = builder.generatePdf() as Data

        /// Return the PDF and the list of songs sorted by page
        return (pdf, counter.tocItems)
    }
}

extension SongExport {

    /// Get all the PDF elements for a song
    /// - Parameters:
    ///   - song: The ``Song``
    ///   - options: The chord display options
    /// - Returns: All the PDF elements in an array
    static func getSongElements(
        song: Song,
        options: ChordDefinition.DisplayOptions,
        counter: PDFBuild.PageCounter
    ) -> [PDFElement] {
        let tocInfo = PDFBuild.TOCInfo(
            title: song.title ?? "Unknown title",
            subtitle: song.artist ?? "Unknown artist",
            fileURL: song.fileURL
        )
        var items: [PDFElement] = []
        items.append(PDFBuild.ContentItem(tocInfo: tocInfo, counter: counter))
        items.append(PDFBuild.Text("\(song.title ?? "No Title")", attributes: .songTitle))
        items.append(PDFBuild.Text("\(song.artist ?? "Unknown Artist")", attributes: .songArtist))
        items.append(PDFBuild.Spacer(10))
        items.append(PDFBuild.SongDetails(song: song))
        items.append(PDFBuild.Spacer(10))
        items.append(PDFBuild.Chords(chords: song.chords, options: options))
        items.append(PDFBuild.Spacer(10))
        /// Add all the sections
        for section in song.sections {
            switch section.type {
            case .chorus:
                items.append(SongExport.lyricsSection(section: section, chords: song.chords))
            case .repeatChorus:
                items.append(SongExport.repeatChorusSection(section: section, chords: song.chords))
            case .verse:
                items.append(SongExport.lyricsSection(section: section, chords: song.chords))
            case .bridge:
                items.append(SongExport.lyricsSection(section: section, chords: song.chords))
            case .comment:
                items.append(SongExport.commentSection(section: section, chords: song.chords))
            case .tab:
                items.append(SongExport.tabSection(section: section, chords: song.chords))
            case .grid:
                items.append(SongExport.gridSection(section: section, chords: song.chords))
            case .textblock:
                items.append(SongExport.textblockSection(section: section, chords: song.chords))
            case .none:
                items.append(SongExport.plainSection(section: section, chords: song.chords))
            case .strum:
                items.append(SongExport.strumSection(section: section, chords: song.chords))
            }
            items.append(PDFBuild.Spacer(10))
        }
        /// Return the items
        return items
    }
}

extension SongExport {

    // MARK: Lyics Section (verse, chord or bridge)

    static func lyricsSection(section: Song.Section, chords: [ChordDefinition]) -> PDFBuild.Section {
        PDFBuild.Section(
            columns: [.fixed(width: 100), .fixed(width: 20), .flexible],
            items: [
                PDFBuild.Label(
                    leadingText: nil,
                    labelText: NSAttributedString(string: section.label, attributes: .sectionLabel),
                    backgroundColor: section.type == .chorus ? .gray.withAlphaComponent(0.3) : .clear,
                    alignment: .right
                ),
                PDFBuild.Divider(direction: .vertical),
                PDFBuild.LyricsSection(section, chords: chords)
            ]
        )
    }
}

extension SongExport {

    // MARK: Tab Section

    static func tabSection(section: Song.Section, chords: [ChordDefinition]) -> PDFBuild.Section {
        PDFBuild.Section(
            columns: [.fixed(width: 100), .fixed(width: 20), .flexible],
            items: [
                PDFBuild.Label(
                    leadingText: nil,
                    labelText: NSAttributedString(string: section.label, attributes: .sectionLabel),
                    backgroundColor: .clear,
                    alignment: .right
                ),
                PDFBuild.Divider(direction: .vertical),
                PDFBuild.TabSection(section)
            ]
        )
    }
}

extension SongExport {

    // MARK: Grid Section

    static func gridSection(section: Song.Section, chords: [ChordDefinition]) -> PDFBuild.Section {
        PDFBuild.Section(
            columns: [.fixed(width: 100), .fixed(width: 20), .flexible],
            items: [
                PDFBuild.Label(
                    leadingText: nil,
                    labelText: NSAttributedString(string: section.label, attributes: .sectionLabel),
                    backgroundColor: .clear,
                    alignment: .right
                ),
                PDFBuild.Divider(direction: .vertical),
                PDFBuild.GridSection(section, chords: chords)
            ]
        )
    }
}

extension SongExport {

    // MARK: Strum Section

    static func strumSection(section: Song.Section, chords: [ChordDefinition]) -> PDFBuild.Section {
        let label = NSAttributedString(string: section.label, attributes: .sectionLabel)
        return PDFBuild.Section(
            columns: [.fixed(width: 100), .fixed(width: 20), .flexible],
            items: [
                PDFBuild.Label(
                    leadingText: nil,
                    labelText: label,
                    backgroundColor: .clear,
                    alignment: .right
                ),
                PDFBuild.Divider(direction: .vertical),
                PDFBuild.StrumSection(section)
            ]
        )
    }
}

extension SongExport {

    // MARK: Textblock Section

    static func textblockSection(section: Song.Section, chords: [ChordDefinition]) -> PDFBuild.Section {
        PDFBuild.Section(
            columns: [.fixed(width: 100), .fixed(width: 20), .flexible],
            items: [
                PDFBuild.Label(
                    leadingText: nil,
                    labelText: NSAttributedString(string: section.label, attributes: .sectionLabel),
                    backgroundColor: .clear,
                    alignment: .right
                ),
                PDFBuild.Divider(direction: .vertical),
                PDFBuild.TextblockSection(section)
            ]
        )
    }
}

extension SongExport {

    // MARK: Plain Section

    static func plainSection(section: Song.Section, chords: [ChordDefinition]) -> PDFBuild.Section {
        PDFBuild.Section(
            columns: [.fixed(width: 110), .flexible],
            items: [
                PDFBuild.Spacer(),
                PDFBuild.PlainSection(section)
            ]
        )
    }
}

extension SongExport {

    // MARK: Comment Section

    static func commentSection(section: Song.Section, chords: [ChordDefinition]) -> PDFBuild.Section {
        PDFBuild.Section(
            columns: [.fixed(width: 110), .flexible],
            items: [
                PDFBuild.Spacer(),
                PDFBuild.Comment(section.lines.first?.comment ?? "Empty comment")
            ]
        )
    }
}

extension SongExport {

    // MARK: Repeat Chorus Section

    static func repeatChorusSection(section: Song.Section, chords: [ChordDefinition]) -> PDFBuild.Section {

        let leadingText = NSAttributedString(string: "􀊯", attributes: .sectionLabel)
        let labelText = NSAttributedString(string: section.label, attributes: .sectionLabel)

        return PDFBuild.Section(
            columns: [.fixed(width: 110), .flexible],
            items: [
                PDFBuild.Spacer(),
                PDFBuild.Label(
                    leadingText: leadingText,
                    labelText: labelText,
                    backgroundColor: .gray.withAlphaComponent(0.3),
                    alignment: .left
                )
            ]
        )
    }
}
