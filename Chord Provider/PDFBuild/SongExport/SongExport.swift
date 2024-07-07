//
//  SongExport.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

/// Export a single ``Song`` to a PDF
enum SongExport {
    // Just a placeholder
}

extension SongExport {

    // MARK: Export a single `Song` to PDF

    /// Export a single song to PDF
    /// - Parameters:
    ///   - song: The ``Song`` to export
    ///   - generalOptions: The general options
    ///   - chordDisplayOptions: The chord display options
    /// - Returns: The song as PDF `Data` and the TOC as a `TOCInfo` array
    static func export(
        song: Song,
        chordDisplayOptions: ChordDefinition.DisplayOptions
    ) throws -> (pdf: Data, toc: [PDFBuild.TOCInfo]) {
        let pdfInfo = PDFBuild.DocumentInfo(
            title: song.metaData.title,
            author: song.metaData.artist
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
        builder.elements.append(
            contentsOf: getSongElements(
                song: song,
                chordDisplayOptions: chordDisplayOptions,
                counter: counter
            )
        )

        /// Generate the PDF
        let pdf = builder.generatePdf() as Data

        /// Return the PDF and the list of songs sorted by page
        return (pdf, counter.tocItems)
    }
}

extension SongExport {

    // MARK: Get all the PDF elements for a `Song`

    /// Get all the PDF elements for a ``Song``
    /// - Parameters:
    ///   - song: The ``Song``
    ///   - generalOptions: The general options
    ///   - chordDisplayOptions: The chord display options
    /// - Returns: All the PDF elements in an array
    // swiftlint:disable:next function_body_length
    static func getSongElements(
        song: Song,
        chordDisplayOptions: ChordDefinition.DisplayOptions,
        counter: PDFBuild.PageCounter
    ) -> [PDFElement] {
        let tocInfo = PDFBuild.TOCInfo(
            id: song.id,
            title: song.metaData.title,
            subtitle: song.metaData.artist,
            fileURL: song.metaData.fileURL
        )
        var items: [PDFElement] = []
        items.append(PDFBuild.ContentItem(tocInfo: tocInfo, counter: counter))
        items.append(PDFBuild.Text("\(song.metaData.title)", attributes: .songTitle))
        items.append(PDFBuild.Text("\(song.metaData.artist)", attributes: .songArtist))
        items.append(PDFBuild.Spacer(10))
        items.append(PDFBuild.SongDetails(song: song))
        items.append(PDFBuild.Spacer(10))
        items.append(PDFBuild.Chords(chords: song.chords, options: chordDisplayOptions))
        items.append(PDFBuild.Spacer(10))
        /// Add all the sections
        for section in song.sections {
            switch section.type {
            case .chorus:
                items.append(lyricsSection(section: section))
            case .repeatChorus:
                items.append(repeatChorusSection(section: section))
            case .verse:
                items.append(lyricsSection(section: section))
            case .bridge:
                items.append(lyricsSection(section: section))
            case .comment:
                items.append(commentSection(section: section))
            case .tab:
                items.append(tabSection(section: section))
            case .grid:
                items.append(gridSection(section: section))
            case .textblock:
                items.append(textblockSection(section: section))
            case .none:
                items.append(plainSection(section: section))
            case .strum:
                items.append(strumSection(section: section))
            }
            items.append(PDFBuild.Spacer(10))
        }
        /// Return the items
        return items

        // MARK: Lyrics Section (verse, chord or bridge)

        /// Add a Lyrics Section (verse, chord or bridge)
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func lyricsSection(section: Song.Section) -> PDFBuild.Section {
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
                    PDFBuild.LyricsSection(section, chords: song.displayOptions.general.lyricsOnly ? [] : song.chords)
                ]
            )
        }

        // MARK: Tab Section

        /// Add a Tab Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func tabSection(section: Song.Section) -> PDFBuild.Section {
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

        // MARK: Grid Section

        /// Add a Grid Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func gridSection(section: Song.Section) -> PDFBuild.Section {
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
                    PDFBuild.GridSection(section, chords: song.chords)
                ]
            )
        }

        // MARK: Strum Section

        /// Add a Strum Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func strumSection(section: Song.Section) -> PDFBuild.Section {
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

        // MARK: Textblock Section

        /// Add a Textblock Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func textblockSection(section: Song.Section) -> PDFBuild.Section {
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

        // MARK: Plain Section

        /// Add a Plain Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func plainSection(section: Song.Section) -> PDFBuild.Section {
            PDFBuild.Section(
                columns: [.fixed(width: 110), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.PlainSection(section)
                ]
            )
        }

        // MARK: Comment Section

        /// Add a Comment Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func commentSection(section: Song.Section) -> PDFBuild.Section {
            PDFBuild.Section(
                columns: [.fixed(width: 110), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.Comment(section.lines.first?.comment ?? "Empty comment")
                ]
            )
        }

        // MARK: Repeat Chorus Section

        /// Add a Repeat Chorus Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func repeatChorusSection(section: Song.Section) -> PDFBuild.Section {
            if
                song.displayOptions.general.repeatWholeChorus,
                let lastChorus = song.sections.last(where: { $0.type == .chorus && $0.label == section.label }) {
                return lyricsSection(section: lastChorus)
            } else {
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
    }
}
