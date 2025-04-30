//
//  SongExport.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// Export a single ``Song`` to a PDF
enum SongExport {
    // Just a placeholder
}

extension SongExport {

    // MARK: Export a single `Song` to PDF

    /// Export a single song to PDF
    /// - Parameters:
    ///   - song: The ``Song`` to export
    /// - Returns: The song as PDF `Data` and the TOC as a `TOCInfo` array
    static func export(
        song: Song
    ) async throws -> (pdf: Data, toc: [PDFBuild.TOCInfo]) {
        Logger.pdfBuild.info("Creating PDF preview for **\(song.metadata.fileURL?.lastPathComponent ?? "New Song", privacy: .public)**")
        let documentInfo = PDFBuild.DocumentInfo(
            title: song.metadata.title,
            author: song.metadata.artist,
            pageRect: song.settings.pdf.pageSize.rect(settings: song.settings),
            pagePadding: song.settings.pdf.pagePadding
        )
        let builder = PDFBuild.Builder(documentInfo: documentInfo, settings: song.settings)
        let counter = PDFBuild.PageCounter(firstPage: 0, attributes: .smallTextFont(settings: song.settings) + .alignment(.center))
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
        var settings = song.settings
        let tocInfo = PDFBuild.TOCInfo(
            song: song
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
        items.append(PDFBuild.Text("\(song.metadata.title)", attributes: .attributes(settings.style.fonts.title) + .alignment(.center)))
        items.append(PDFBuild.Text("\(subtitle.joined(separator: "・"))", attributes: .attributes(settings.style.fonts.subtitle) + .alignment(.center)))

        if settings.pdf.showTags {
            items.append(PDFBuild.Tags(song: song, settings: settings))
        }

        items.append(PDFBuild.Spacer(10))

        if !settings.shared.lyricsOnly, !song.chords.isEmpty {
            items.append(PDFBuild.SongDetails(song: song, settings: settings))
            items.append(PDFBuild.Spacer(10))
            items.append(PDFBuild.Chords(chords: song.chords, settings: settings))
            items.append(PDFBuild.Spacer(10))
        }

        // MARK: Calculate label size

        let longestLabel = NSAttributedString(
            string: song.metadata.longestLabel,
            attributes: .attributes(settings.style.fonts.label)
        )
        let longestLabelBounds = longestLabel.boundingRect(
            with: settings.pdf.pageSize.rect(settings: settings).size,
            options: .usesLineFragmentOrigin
        )
        let labelWidth = longestLabelBounds.width + 14

        // MARK: Calculate longest line

        let longestLine = NSAttributedString(
            string: song.metadata.longestLine,
            attributes: .attributes(settings.style.fonts.text)
        )
        let longestLineBounds = longestLine.boundingRect(
            with: settings.pdf.pageSize.rect(settings: settings).size,
            options: .usesLineFragmentOrigin
        )

        // MARK: Calculate scale

        let availableWidth = settings.pdf.pageSize.rect(
            settings: settings
        ).width - labelWidth - (settings.pdf.pagePadding * 2) - 60

        if availableWidth < longestLineBounds.width {
            if settings.pdf.scaleFonts {
                settings.pdf.scale = availableWidth / longestLineBounds.width
            }
            Logger.pdfBuild.warning("Content of **\(song.metadata.fileURL?.lastPathComponent ?? "New Song", privacy: .public)** does not fit")
        }

        // MARK: Calculate offset

        var offset: Double = 0
        let pagePadding = availableWidth - longestLineBounds.width
        if settings.pdf.centerContent {
            /// When the longest line does not fit on the page, use 0 as offset
            offset = pagePadding > 0 ? pagePadding / 2 : 0
        }

        // MARK: Calculate maximum content size

        let content = availableWidth - offset + 40

        /// Add all the sections, except metadata stuff
        for section in song.sections where !ChordPro.Environment.unsupported.contains(section.environment) {
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
                if !settings.shared.lyricsOnly {
                    items.append(tabSection(section: section))
                }
            case .grid:
                if !settings.shared.lyricsOnly {
                    items.append(gridSection(section: section))
                }
            case .textblock:
                items.append(textblockSection(section: section))
            case .strum:
                if !settings.shared.lyricsOnly {
                    items.append(strumSection(section: section))
                }
            case .image:
                await items.append(imageSection(section: section, fileURL: song.metadata.fileURL))
            default:
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
                columns: [.fixed(width: offset), .fixed(width: labelWidth), .fixed(width: 20), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.Label(
                        labelText: section.label,
                        drawBackground: section.environment == .chorus ? true : false,
                        alignment: .right,
                        fontOptions: settings.style.fonts.label
                    ),
                    PDFBuild.Divider(direction: .vertical, color: settings.style.theme.foregroundLight.nsColor),
                    PDFBuild.LyricsSection(section, chords: song.settings.shared.lyricsOnly ? [] : song.chords, settings: settings)
                ]
            )
        }

        // MARK: Tab Section

        /// Add a Tab Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func tabSection(section: Song.Section) -> PDFBuild.Section {
            PDFBuild.Section(
                columns: [.fixed(width: offset), .fixed(width: labelWidth), .fixed(width: 20), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.Label(
                        labelText: section.label,
                        drawBackground: false,
                        alignment: .right,
                        fontOptions: settings.style.fonts.label
                    ),
                    labelDivider(section: section),
                    PDFBuild.TabSection(section, settings: settings)
                ]
            )
        }

        // MARK: Grid Section

        /// Add a Grid Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func gridSection(section: Song.Section) -> PDFBuild.Section {
            PDFBuild.Section(
                columns: [.fixed(width: offset), .fixed(width: labelWidth), .fixed(width: 20), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.Label(
                        labelText: section.label,
                        drawBackground: false,
                        alignment: .right,
                        fontOptions: settings.style.fonts.label
                    ),
                    labelDivider(section: section),
                    PDFBuild.GridSection(section, chords: song.chords, settings: settings)
                ]
            )
        }

        // MARK: Strum Section

        /// Add a Strum Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func strumSection(section: Song.Section) -> PDFBuild.Section {
            return PDFBuild.Section(
                columns: [.fixed(width: offset), .fixed(width: labelWidth), .fixed(width: 20), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.Label(
                        labelText: section.label,
                        drawBackground: false,
                        alignment: .right,
                        fontOptions: settings.style.fonts.label
                    ),
                    labelDivider(section: section),
                    PDFBuild.StrumSection(section, settings: settings)
                ]
            )
        }

        // MARK: Textblock Section

        /// Add a Textblock Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func textblockSection(section: Song.Section) -> PDFBuild.Section {
            PDFBuild.Section(
                columns: [.fixed(width: offset), .fixed(width: labelWidth), .fixed(width: 20), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.Label(
                        labelText: section.label,
                        drawBackground: false,
                        alignment: .right,
                        fontOptions: settings.style.fonts.label
                    ),
                    labelDivider(section: section),
                    PDFBuild.TextblockSection(section, availableWidth: content, settings: settings)
                ]
            )
        }

        // MARK: Plain Section

        /// Add a Plain Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func plainSection(section: Song.Section) -> PDFBuild.Section {
            PDFBuild.Section(
                columns: [.fixed(width: offset), .fixed(width: 110), .flexible],
                items: [
                    PDFBuild.Spacer(),
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
                columns: [.fixed(width: offset), .fixed(width: labelWidth + 26), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.Spacer(),
                    PDFBuild.Comment(section.lines.first?.plain ?? "Empty comment", settings: settings)
                ]
            )
        }

        // MARK: Repeat Chorus Section

        /// Add a Repeat Chorus Section
        /// - Parameter section: The current section
        /// - Returns: A ``PDFBuild/Section`` element
        func repeatChorusSection(section: Song.Section) -> PDFBuild.Section {
            if
                song.settings.shared.repeatWholeChorus,
                let lastChorus = song.sections.last(where: { $0.environment == .chorus && $0.label == section.label }) {
                return lyricsSection(section: lastChorus)
            } else {
                return PDFBuild.Section(
                    columns: [.fixed(width: offset), .fixed(width: labelWidth + 26), .flexible],
                    items: [
                        PDFBuild.Spacer(),
                        PDFBuild.Spacer(),
                        PDFBuild.Label(
                            labelText: section.label,
                            sfSymbol: .repeatChorus,
                            drawBackground: true,
                            alignment: .left,
                            fontOptions: settings.style.fonts.label
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
                    columns: [.fixed(width: offset), .fixed(width: labelWidth + 10), .flexible],
                    items: [
                        PDFBuild.Spacer(),
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
                columns: [.fixed(width: offset), .fixed(width: labelWidth + 10), .flexible],
                items: [
                    PDFBuild.Spacer(),
                    PDFBuild.Spacer(),
                    PDFBuild.Comment("Image not available", settings: settings)
                ]
            )
        }

        // MARK: Label Divider

        /// Calculate the type of divider for a section
        /// - Parameter section: The ``Song/Section``
        /// - Returns: A ``PDFBuild/Spacer`` or a ``PDFBuild/Divider``
        /// - Note: If the label is empty, a spacer is returned, else a divider
        func labelDivider(section: Song.Section) -> PDFElement {
            section.label.isEmpty ? PDFBuild.Spacer() : PDFBuild.Divider(direction: .vertical, color: settings.style.theme.foregroundLight.nsColor)
        }
    }
}
