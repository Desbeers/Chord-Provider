//
//  PDFBuild+StrumSection+Line+Part.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild.StrumSection.Line {

    // MARK: A PDF **part** element for a `Line` in a `StrumSection`

    /// A PDF **part** element for a `Line` in a `StrumSection`
    ///
    /// Display a part of a line of a strum section of the song
    class Part: PDFElement {

        /// The text of the part
        /// - Note: A merge of the optional chord and optional lyrics part
        let text = NSMutableAttributedString()
        /// The size of the part
        let size: CGSize
        /// The application settings
        let settings: AppSettings
        /// The part of the strum
        let part: Song.Section.Line.Strum

        /// Init the **part** element
        /// - Parameters:
        ///   - part: The part of the strum line
        ///   - settings: The application settings
        init(part: Song.Section.Line.Strum, settings: AppSettings) {
            self.part = part
            self.text.append(
                NSAttributedString(
                    string: "\(part.beat.isEmpty ? part.tuplet : part.beat)",
                    attributes: .strumLineBeat(settings: settings)
                )
            )
            self.settings = settings
            let textBounds = text.boundingRect(with: CGSize(width: 100, height: 100))
            self.size = .init(width: settings.style.fonts.text.size, height: (settings.style.fonts.text.size * 2.2) + (textBounds.height * 2))
        }

        /// Draw the **part** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            let x = settings.style.fonts.text.size / 2
            let length = settings.style.fonts.text.size * 2
            let dash = part.action == .slowUp || part.action == .slowDown ? true : false
            if !calculationOnly {
                let symbol = NSAttributedString(string: part.topSymbol, attributes: .strumLine(settings: settings))
                symbol.draw(with: rect, options: textDrawingOptions, context: nil)
                let size = symbol.size()
                rect.origin.y += size.height
                rect.size.height -= size.height
                var textRect = rect
                textRect.origin.y += length * 1.1
                var symbolRect = rect
                symbolRect.origin.y += length - settings.style.fonts.text.size
                switch part.action {
                case .down, .accentedDown, .mutedDown, .slowDown:
                    drawArrow(start: CGPoint(x: x, y: 0), end: CGPoint(x: x, y: length), dash: dash, rect: rect)
                case .up, .accentedUp, .mutedUp, .slowUp:
                    drawArrow(start: CGPoint(x: x, y: length), end: CGPoint(x: x, y: 0), dash: dash, rect: rect)
                case .palmMute:
                    let text = NSAttributedString(string: "x", attributes: .strumLine(settings: settings))
                    text.draw(with: symbolRect, options: textDrawingOptions, context: nil)
                default:
                    break
                }
                text.draw(with: textRect, options: textDrawingOptions, context: nil)
            }
        }

        /// Draw an arrow
        /// - Parameters:
        ///   - start: Start point
        ///   - end: End point
        ///   - dash: Bool to draw the arrow with dashes
        ///   - rect: The available rectangle
        func drawArrow(start: CGPoint, end: CGPoint, dash: Bool = false, rect: CGRect) {
            let lineWidth: Double = 0.5
            let vlen: Double = sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))
            let tipWidth: Double = vlen / 12
            let tipHeight: Double = vlen / 5
            let start = (x: start.x + rect.origin.x, y: start.y + rect.origin.y)
            let end = (x: end.x + rect.origin.x, y: end.y + rect.origin.y)
            let eShorten = (x: end.x - lineWidth * (end.x - start.x) / vlen, y: end.y - lineWidth * (end.y - start.y) / vlen)
            let tipBase = (x: end.x - tipHeight * (end.x - start.x) / vlen, y: end.y - tipHeight * (end.y - start.y) / vlen)
            let vTip = (x: (start.y - end.y) / vlen, y: (end.x - start.x) / vlen)
            let tip1vert = (x: tipBase.x + tipWidth * vTip.x, y: tipBase.y + tipWidth * vTip.y)
            let tip2vert = (x: tipBase.x - tipWidth * vTip.x, y: tipBase.y - tipWidth * vTip.y)
            if let context = NSGraphicsContext.current?.cgContext {
                /// Draw the line
                context.move(to: CGPoint(x: start.x, y: start.y))
                /// Prevents the end of the line from protruding from the tip
                context.addLine(to: CGPoint(x: eShorten.x, y: eShorten.y))
                context.setStrokeColor(settings.style.theme.foregroundMedium.nsColor.cgColor)
                if dash {
                    context.setLineDash(phase: 0, lengths: [2, 2])
                }
                context.setLineWidth(lineWidth)
                context.setLineCap(.round)
                context.strokePath()
                context.setLineDash(phase: 0, lengths: [])
                /// Draw the tip
                context.move(to: CGPoint(x: end.x, y: end.y))
                context.addLine(to: CGPoint(x: tip1vert.x, y: tip1vert.y))
                context.addLine(to: CGPoint(x: tip2vert.x, y: tip2vert.y))
                context.closePath()
                context.setFillColor(settings.style.theme.foregroundMedium.nsColor.cgColor)
                context.fillPath()
            }
        }
    }
}
