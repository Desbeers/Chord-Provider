//
//  SongExport.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import OSLog

/// Export a single ``Song`` to a PDF
enum SongExport {
    // Just a placeholder
}

extension SongExport {

    // MARK: Export a single `Song` to PDF

    /// Export a single song to PDF
    /// - Parameter song: The ``Song`` to export
    /// - Returns: The song as PDF `Data` and the TOC as a `TOCInfo` array
    static func export(
        song: Song
    ) async throws -> (pdf: Data, toc: [PDFBuild.TOCInfo]) {
        Logger.pdfBuild.info("Creating PDF preview for **\(song.metadata.fileURL?.lastPathComponent ?? "New Song", privacy: .public)**")
        let documentInfo = PDFBuild.DocumentInfo(
            title: song.metadata.title,
            author: song.metadata.artist
        )
        let builder = PDFBuild.Builder(documentInfo: documentInfo)
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
        await builder.elements.append(
            contentsOf: getSongElements(
                song: song,
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
    ///   - counter: The ``PDFBuild/PageCounter`` class
    /// - Returns: All the PDF elements in an array
    // swiftlint:disable:next function_body_length
    static func getSongElements(
        song: Song,
        counter: PDFBuild.PageCounter
    ) async -> [PDFElement] {
        let tocInfo = PDFBuild.TOCInfo(
            id: song.id,
            title: song.metadata.title,
            subtitle: song.metadata.artist,
            fileURL: song.metadata.fileURL
        )
        var subtitle: [String] = [song.metadata.artist]
        if let album = song.metadata.album {
            subtitle.append(album)
        }
        if let year = song.metadata.year {
            subtitle.append(year)
        }
        var items: [PDFElement] = []
        items.append(PDFBuild.ContentItem(tocInfo: tocInfo, counter: counter))
        items.append(PDFBuild.Text("\(song.metadata.title)", attributes: .pdfTitle))
        items.append(PDFBuild.Text("\(subtitle.joined(separator: "・"))", attributes: .pdfSubtitle))
        items.append(PDFBuild.Spacer(10))
        items.append(PDFBuild.SongDetails(song: song))
        items.append(PDFBuild.Spacer(10))
        if !song.chords.isEmpty {
            items.append(PDFBuild.Chords(chords: song.chords, options: song.settings.diagram))
        }
        items.append(PDFBuild.Spacer(10))

        // MARK: Calculate label size

        /// Default value
        var labelWidth: Double = 100
        let labels = song.sections.map(\.label)
        if let max = labels.max(by: { $1.count > $0.count }) {
            let text = NSAttributedString(
                string: max,
                attributes: .sectionLabel
            )
            let textBounds = text.boundingRect(with: PDFBuild.a4portraitPage.size, options: .usesLineFragmentOrigin)
            labelWidth = textBounds.width + 8
        }

        /// Add all the sections, except metadata stuff
        for section in song.sections where section.environment != .metadata {
            switch section.environment {
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
            case .strum:
                items.append(strumSection(section: section))
            case .image:
                await items.append(imageSection(section: section, fileURL: song.metadata.fileURL))
            case .abc:
                /// Not supported
                break
            case .metadata, .none:
                break
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
                columns: [.fixed(width: labelWidth), .fixed(width: 20), .flexible],
                items: [
                    PDFBuild.Label(
                        leadingText: nil,
                        labelText: NSAttributedString(string: section.label, attributes: .sectionLabel),
                        backgroundColor: section.environment == .chorus ? .gray.withAlphaComponent(0.3) : .clear,
                        alignment: .right
                    ),
                    PDFBuild.Divider(direction: .vertical),
                    PDFBuild.LyricsSection(section, chords: song.settings.display.lyricsOnly ? [] : song.chords)
                ]
            )
        }

        // MARK: Tab Section

        /// Add a Tab Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func tabSection(section: Song.Section) -> PDFBuild.Section {
            PDFBuild.Section(
                columns: [.fixed(width: labelWidth), .fixed(width: 20), .flexible],
                items: [
                    PDFBuild.Label(
                        leadingText: nil,
                        labelText: NSAttributedString(string: section.label, attributes: .sectionLabel),
                        backgroundColor: .clear,
                        alignment: .right
                    ),
                    labelDivider(section: section),
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
                columns: [.fixed(width: labelWidth), .fixed(width: 20), .flexible],
                items: [
                    PDFBuild.Label(
                        leadingText: nil,
                        labelText: NSAttributedString(string: section.label, attributes: .sectionLabel),
                        backgroundColor: .clear,
                        alignment: .right
                    ),
                    labelDivider(section: section),
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
                columns: [.fixed(width: labelWidth), .fixed(width: 20), .flexible],
                items: [
                    PDFBuild.Label(
                        leadingText: nil,
                        labelText: label,
                        backgroundColor: .clear,
                        alignment: .right
                    ),
                    labelDivider(section: section),
                    PDFBuild.StrumSection(section)
                ]
            )
        }

        // MARK: Textblock Section

        /// Add a Textblock Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func textblockSection(section: Song.Section) -> PDFBuild.Section {
            return PDFBuild.Section(
                columns: [.fixed(width: labelWidth), .fixed(width: 20), .flexible],
                items: [
                    PDFBuild.Label(
                        leadingText: nil,
                        labelText: NSAttributedString(string: section.label, attributes: .sectionLabel),
                        backgroundColor: .clear,
                        alignment: .right
                    ),
                    labelDivider(section: section),
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
                columns: [.fixed(width: labelWidth + 26), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.Comment(section.lines.first?.label ?? "Empty comment")
                ]
            )
        }

        // MARK: Repeat Chorus Section

        /// Add a Repeat Chorus Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func repeatChorusSection(section: Song.Section) -> PDFBuild.Section {
            if
                song.settings.display.repeatWholeChorus,
                let lastChorus = song.sections.last(where: { $0.environment == .chorus && $0.label == section.label }) {
                return lyricsSection(section: lastChorus)
            } else {
                let leadingText = NSAttributedString(string: "􀊯", attributes: .sectionLabel)
                let labelText = NSAttributedString(string: section.label, attributes: .sectionLabel)
                return PDFBuild.Section(
                    columns: [.fixed(width: labelWidth + 26), .flexible],
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

        // MARK: Image Section

        /// Add a Comment Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func imageSection(section: Song.Section, fileURL: URL?) async -> PDFBuild.Section {
            var arguments = section.arguments
            if arguments?[.align] == nil {
                /// Set the default
                arguments?[.align] = "center"
            }
            if let source = arguments?[.src], let image = await loadImage(source: source, fileURL: fileURL) {
                return PDFBuild.Section(
                    columns: [.fixed(width: labelWidth + 10), .flexible],
                    items: [
                        PDFBuild.Spacer(),
                        PDFBuild.Image(
                            image,
                            size: ChordProParser.getImageSize(image: image, arguments: arguments),
                            alignment: PDFBuild.getAlign(arguments),
                            offset: ChordProParser.getOffset(arguments)
                        )
                    ]
                )
            }
            return PDFBuild.Section(
                columns: [.fixed(width: labelWidth + 10), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.Comment("Image not available", icon: "􀏅", backgroundColor: .pdfTelecaster)
                ]
            )
        }
    }
}


extension SongExport {

    static func labelDivider(section: Song.Section) -> PDFElement {
        section.label.isEmpty ? PDFBuild.Spacer() : PDFBuild.Divider(direction: .vertical)
    }
}
