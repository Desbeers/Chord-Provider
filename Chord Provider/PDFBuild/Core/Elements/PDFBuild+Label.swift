//
//  PDFBuild+Label.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **label** element

    /// A PDF **label** element
    class Label: PDFElement {

        /// The text of the label
        let labelText: String
        /// Optional SF Symbol icon
        let sfSymbol: SFSymbol?
        /// Bool to draw a background or not
        let drawBackground: Bool
        /// The alignment of the label
        let alignment: NSTextAlignment
        /// The corner radius of the label
        let cornerRadius: CGFloat = 3
        /// The font options
        let fontOptions: ConfigOptions.FontOptions

        /// Init the **label** element
        /// - Parameters:
        ///   - labelText: The text of the label
        ///   - sfSymbol: Optional SF Symbol icon
        ///   - drawBackground: Bool to draw a background or not
        ///   - alignment: The alignment of the label
        ///   - fontOptions: The font options
        init(
            labelText: String,
            sfSymbol: SFSymbol? = nil,
            drawBackground: Bool,
            alignment: NSTextAlignment,
            fontOptions: ConfigOptions.FontOptions
        ) {
            self.labelText = labelText
            self.sfSymbol = sfSymbol
            self.drawBackground = drawBackground
            self.alignment = alignment
            self.fontOptions = fontOptions
        }
        /// Draw the **label** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {

            // MARK: Calculated results

            var section: PDFBuild.Section?
            var result: (any PDFElement)?
            var labelWidth: Double = 0

            let label = NSAttributedString(labelText.toMarkdown(fontOptions: fontOptions, scale: 1))

            if let sfSymbol {
                let image = PDFBuild.Image(sfSymbol, fontSize: fontOptions.size, colors: [fontOptions.color.nsColor])
                result = PDFBuild.Section(
                    columns: [.fixed(width: image.image.size.width + 2 * textPadding), .flexible],
                    items: [
                        image.padding(textPadding * 2),
                        PDFBuild.Text(label).padding(textPadding)
                    ]
                )
                /// Calculate the total label width
                var labelRect = rect
                labelRect.size.width -= image.image.size.width + 4 * textPadding
                let bounds = label.boundingRect(with: labelRect.size, options: [])
                labelWidth = (8 * textPadding) + bounds.width + image.image.size.width
            } else {
                /// The label is text only
                let bounds = label.boundingRect(with: rect.size, options: [])
                labelWidth = (4 * textPadding) + bounds.width
                result = PDFBuild.Text(label).padding(textPadding)
            }

            if let result {

                var content = result

                if drawBackground {
                    content = PDFBuild.Background(color: fontOptions.background.nsColor, result).clip(.cornerRect(cornerRadius: cornerRadius))
                }

                switch alignment {
                case .center:
                    section = PDFBuild.Section(
                        columns: [.flexible, .fixed(width: labelWidth), .flexible],
                        items: [
                            PDFBuild.Spacer(),
                            content,
                            PDFBuild.Spacer()
                        ]
                    )
                case .right:
                    section = PDFBuild.Section(
                        columns: [.flexible, .fixed(width: labelWidth)],
                        items: [
                            PDFBuild.Spacer(),
                            content
                        ]
                    )
                default:
                    section = PDFBuild.Section(
                        columns: [.fixed(width: labelWidth), .flexible],
                        items: [
                            content,
                            PDFBuild.Spacer()
                        ]
                    )
                }
            }
            /// There should always be a section...
            if let section {
                section.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
            }
        }
    }
}
