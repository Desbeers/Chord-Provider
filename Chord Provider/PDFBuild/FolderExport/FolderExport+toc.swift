//
//  FolderExport+toc.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension FolderExport {

    /// Create a Table of Contents
    /// - Parameters:
    ///   - documentInfo: The document info for the PDF
    ///   - counter: The `page counter` class
    ///   - settings: The application settings
    /// - Returns: The Table of Contents as `Data`
    static func toc(
        documentInfo: PDFBuild.DocumentInfo,
        counter: PDFBuild.PageCounter,
        settings: AppSettings
    ) -> Data {
        /// Divide sections by artist of first letter of title
        var divider: String = ""

        let tocBuilder = PDFBuild.Builder(documentInfo: documentInfo, settings: settings)
        tocBuilder.pageCounter = counter
        tocBuilder.elements.append(PDFBuild.PageBackgroundColor(color: .black))
        tocBuilder.elements.append(PDFBuild.Text(
            documentInfo.title,
            attributes: .exportTitle(settings: settings))
        )
        tocBuilder.elements.append(PDFBuild.Text(
            documentInfo.author,
            attributes: .exportAuthor(settings: settings)
        )
            .padding(settings.pdf.pagePadding))
        /// Add **Chord Provider** icon
        let size = documentInfo.pageRect.height / 2

        if let image = NSImage(named: "AppIcon") {
            tocBuilder.elements.append(PDFBuild.Image(image, size: CGSize(width: size, height: size)))
        }
        tocBuilder.elements.append(PDFBuild.PageBreak())
        tocBuilder.elements.append(
            PDFBuild.Text(
                "Table of Contents",
                attributes: .attributes(settings.style.fonts.title) + .alignment(.center)
            )
        )
        for tocInfo in counter.tocItems {
            /// Add a divider between all artists when the songs are sorted by artist
            if settings.application.songListSort == .artist, divider != tocInfo.song.metadata.artist {
                /// Add a divider
                tocBuilder.elements.append(
                    PDFBuild.Divider(direction: .horizontal, color: settings.style.theme.foregroundLight.nsColor)
                        .padding(10)
                )
                /// Remember the artist
                divider = tocInfo.song.metadata.artist
            }
            /// Add a divider between all first letter of titles when the songs are sorted by song title
            if settings.application.songListSort == .song, divider != tocInfo.song.metadata.sortTitle.prefix(1).lowercased() {
                /// Add a divider
                tocBuilder.elements.append(
                    PDFBuild.Divider(direction: .horizontal, color: settings.style.theme.foregroundLight.nsColor)
                        .padding(10)
                )
                /// Remember the first letter
                divider = String(tocInfo.song.metadata.sortTitle.prefix(1).lowercased())
            }

            tocBuilder.elements.append(PDFBuild.TOCItem(tocInfo: tocInfo, counter: counter, settings: settings))
        }
        return tocBuilder.generatePdf()
    }
}

extension PDFStringAttribute {

    /// Style attributes for the export title
    static func exportTitle(settings: AppSettings) -> PDFStringAttribute {
        let font = NSFont(name: settings.style.fonts.title.font.postScriptName, size: 28) ?? NSFont.systemFont(ofSize: 28)
        return [
            .foregroundColor: NSColor.white,
            .font: font
        ] + .alignment(.center)
    }

    /// Style attributes for the export author
    static func exportAuthor(settings: AppSettings) -> PDFStringAttribute {
        let font = NSFont(name: settings.style.fonts.subtitle.font.postScriptName, size: 24) ?? NSFont.systemFont(ofSize: 28)
        return [
            .foregroundColor: NSColor.gray,
            .font: font
        ] + .alignment(.center)
    }
}
