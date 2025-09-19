//
//  PDFBuild+TextblockSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import ChordProviderCore

extension PDFBuild {

    // MARK: A PDF **textblock section** element

    /// A PDF **textblock section** element
    ///
    /// Display a textblock section of the song
    class TextblockSection: PDFElement {

        /// The section with textblock
        let section: Song.Section
        /// The application settings
        let settings: AppSettings
        /// The available width of the textblock
        let availableWidth: Double

        /// Init the **textblock section** element
        /// - Parameters:
        ///   - section: The section with textblock
        ///   - availableWidth: The available width of the textblock
        ///   - settings: The application settings
        init(_ section: Song.Section, availableWidth: Double, settings: AppSettings) {
            self.section = section
            self.settings = settings
            self.availableWidth = availableWidth
        }

        /// Draw the **textblock section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {

            var tmpRect = rect
            tmpRect.size.width = availableWidth

            var maxSize: Double = 0

            /// In **ChordPro**, the attribute 'flush' is the actual alignment of the text; *not* the placement in the page
            let flush = getFlush(section.arguments)
            let align = getAlign(section.arguments)
            var elements: [PDFElement] = []
            for line in section.lines {
                switch line.type {
                case .songLine:
                    var string = line.plain?.toMarkdown(fontOptions: settings.style.fonts.textblock, scale: 1) ?? AttributedString()
                    let paragraphStyle = string.paragraphStyle as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
                    paragraphStyle.lineHeightMultiple = 1.2
                    paragraphStyle.alignment = flush
                    var attributes = AttributeContainer()
                    attributes.paragraphStyle = paragraphStyle
                    string.mergeAttributes(attributes, mergePolicy: .keepNew)
                    /// Convert to a `NSMutableAttributedString`
                    let line = NSMutableAttributedString(string)
                    /// Remember the longest line
                    maxSize = max(maxSize, line.boundingRect(with: tmpRect.size, options: .usesLineFragmentOrigin).width)
                    elements.append(PDFBuild.Text(line))
                case .emptyLine:
                    let spacer = PDFBuild.Spacer(settings.style.fonts.textblock.size / 2)
                    elements.append(spacer)
                case .comment:
                    let comment = PDFBuild.Comment(line.plain ?? "", settings: settings, alignment: flush).padding(6)
                    elements.append(comment)
                default:
                    break
                }
            }
            /// Align the textblock with the optional 'align' attribute
            tmpRect.size.width = maxSize + (textPadding * 2)
            let offset = availableWidth - maxSize
            switch align {
            case .left:
                /// Nothing to alter
                break
            case .center:
                tmpRect.origin.x += offset / 2
            case .right:
                tmpRect.origin.x += offset
            default:
                /// Nothing to alter
                break
            }
            /// Draw the elements
            for element in elements {
                element.draw(rect: &tmpRect, calculationOnly: calculationOnly, pageRect: pageRect)
            }
            /// Set the sizes
            rect.size.height = tmpRect.size.height
            rect.origin.y = tmpRect.origin.y
        }
    }
}
