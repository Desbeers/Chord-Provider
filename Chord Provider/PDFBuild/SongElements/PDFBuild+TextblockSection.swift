//
//  PDFBuild+TextblockSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **textblock section** element

    /// A PDF **textblock section** element
    ///
    /// Display a textblock section of the song
    class TextblockSection: PDFElement {

        /// The section with textblock
        let section: Song.Section
        /// All the chords of the song
        let chords: [ChordDefinition]
        /// The application settings
        let settings: AppSettings

        /// Init the **textblock section** element
        /// - Parameters:
        ///   - section: The section with textblock
        ///   - chords: All the chords of the song
        ///   - settings: The application settings
        init(_ section: Song.Section, chords: [ChordDefinition], settings: AppSettings) {
            self.section = section
            self.chords = chords
            self.settings = settings
        }

        /// Draw the **textblock section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// In **ChordPro**, the attribute 'flush' is the actual alignment of the text; *not* the placement in the page
            let flush = getFlush(section.arguments)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = flush
            paragraphStyle.lineSpacing = 4
            let text = NSMutableAttributedString()
            for line in section.lines {
                switch line.directive {
                case .environmentLine:
                    if let parts = line.parts {
                        for part in parts {
                            if let chord = chords.first(where: { $0.id == part.chord }) {
                                text.append(
                                    NSAttributedString(
                                        /// Add a space behind the chord-name so two chords will never 'stick' together
                                        string: "\(chord.display)",
                                        attributes: .partChord(settings: settings)
                                    )
                                )
                            }
                            text.append(NSAttributedString(
                                string: "\(part.text)",
                                attributes: .textblockLine(settings: settings))
                            )
                        }
                        if line != section.lines.last {
                            text.append(NSAttributedString(string: "\n"))
                        }
                    }
                case .comment:
                    text.append(NSAttributedString(string: "\u{270d} \(line.plain)\n", attributes: .attributes(.comment, settings: settings)))
                default:
                    break
                }
            }
            text.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: text.length))
            let textBounds = text.boundingRect(with: rect.size, options: .usesLineFragmentOrigin)

            /// Align the textblock with the optional 'align' attribute
            var tmpRect = rect
            tmpRect.size.width = textBounds.width
            let align = getAlign(section.arguments)
            switch align {
            case .left:
                tmpRect.size.width = textBounds.width
            case .center:
                let offset = (pageRect.width - textBounds.width) / 2
                tmpRect.origin.x = offset
            case .right:
                let offset = rect.width - textBounds.width
                tmpRect.origin.x += offset
            default:
                /// Nothing to alter
                break
            }
            /// Add the optional label
            var labelRect = tmpRect
            if !section.label.isEmpty {
                let label = PDFBuild.Text(section.label, attributes: .attributes(.label, settings: settings) + .alignment(flush))
                label.draw(rect: &labelRect, calculationOnly: calculationOnly, pageRect: pageRect)
                let divider = PDFBuild.Divider(direction: .horizontal)
                divider.draw(rect: &labelRect, calculationOnly: calculationOnly, pageRect: pageRect)
            }
            /// Add the label height
            let labelHeight = rect.height - labelRect.height
            tmpRect.origin.y += labelHeight
            tmpRect.size.height -= labelHeight
            /// Draw the content of the textblock
            if !calculationOnly {
                text.draw(with: tmpRect, options: textDrawingOptions, context: nil)
            }
            let height = (textBounds.height + 2 * textPadding) + labelHeight
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

extension PDFStringAttribute {

    // MARK: Textblock string styling

    /// String attributes for a textblock  line
    static func textblockLine(settings: AppSettings) -> PDFStringAttribute {
        [
            .foregroundColor: NSColor(settings.style.fonts.textblock.color),
            .font: NSFont.systemFont(ofSize: settings.style.fonts.textblock.size)
        ]
    }
}
