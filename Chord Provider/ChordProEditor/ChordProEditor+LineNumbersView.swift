//
//  ChordProEditor+LineNumbersView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension ChordProEditor {

    // MARK: The line numbers view for the editor

    /// The line numbers view for the editor
    class LineNumbersView: NSRulerView {

        // MARK: Override draw

        /// Draw a background a a stroke on the right of the `NSRulerView`
        /// - Parameter dirtyRect: The current rect of the editor
        override func draw(_ dirtyRect: NSRect) {
            guard
                let context: CGContext = NSGraphicsContext.current?.cgContext
            else {
                return
            }
            /// Fill the background
            context.setFillColor(Editor.highlightedBackgroundColor.cgColor)
            context.fill(bounds)
            /// Draw a border on the right
            context.setStrokeColor(NSColor.secondaryLabelColor.cgColor)
            context.setLineWidth(0.5)
            context.move(to: CGPoint(x: bounds.width - 1, y: 0))
            context.addLine(to: CGPoint(x: bounds.width - 1, y: bounds.height))
            context.strokePath()
            /// - Note: Below usually gets called on super.draw(dirtyRect),
            ///         but we're not calling it because that will override the background color
            drawHashMarksAndLabels(in: bounds)
        }

        // MARK: Override drawHashMarksAndLabels

        /// Draw line numbers and symbols in the ruler of the text view
        /// - Parameter rect: The available rect
        override func drawHashMarksAndLabels(in rect: NSRect) {
            guard
                let textView: TextView = self.clientView as? TextView,
                let textContainer: NSTextContainer = textView.textContainer,
                let layoutManager: LayoutManager = textView.layoutManager as? LayoutManager,
                let context: CGContext = NSGraphicsContext.current?.cgContext
            else {
                return
            }

            // MARK: Setup variables

            /// Get the current font
            let font: NSFont = layoutManager.font
            /// Set the width of the ruler
            ruleThickness = font.pointSize * 4
            /// The line number
            var lineNumber: Int = 1
            /// Get the range of glyphs in the visible area of the text view
            let visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: textView.visibleRect, in: textContainer)
            /// Set the context based on the Y-offset of the text view
            context.translateBy(x: 0, y: convert(NSPoint.zero, from: textView).y)

            // MARK: Set first line number

            /// The line number for the first visible line
            lineNumber += Editor.newLineRegex.numberOfMatches(
                in: textView.string,
                options: [],
                range: NSRange(location: 0, length: visibleGlyphRange.location)
            )

            // MARK: Draw marks

            /// Go to all paragraphs
            if let visibleSwiftRange = Range(visibleGlyphRange, in: textView.string) {
                textView.string.enumerateSubstrings(
                    in: visibleSwiftRange,
                    options: [.byParagraphs]
                ) { _, substringRange, _, _ in
                    let nsRange = NSRange(substringRange, in: textView.string)
                    let paragraphRect = layoutManager.boundingRect(forGlyphRange: nsRange, in: textContainer)
                    /// Set the marker rect
                    let markerRect = NSRect(
                        x: 0,
                        y: paragraphRect.origin.y,
                        width: rect.width,
                        height: paragraphRect.height
                    )
                    /// Bool if the line should be highlighted
                    let highlight = markerRect.minY == textView.currentParagraphRect?.minY
                    /// The content of the current line
                    let line = textView.getCurrentLine(lineNumber: lineNumber)
                    /// Bool if the line contains a warning
                    let warning: Bool = line.warnings != nil
                    /// Draw the line number
                    drawLineNumber(
                        lineNumber,
                        inRect: markerRect,
                        highlight: highlight,
                        warning: warning,
                        icon: line.directive?.details.icon ?? line.type.icon
                    )
                    if highlight {
                        /// Set the current line of the cursor
                        textView.currentLine = line
                        textView.currentDirectiveArguments = line.arguments ?? ChordProParser.DirectiveArguments()
                    }
                    lineNumber += 1
                }
            }

            /// Draw line number for the optional extra (empty) line at the end of the text
            if layoutManager.extraLineFragmentTextContainer != nil {
                /// Set the marker rect
                let markerRect = NSRect(
                    x: 0,
                    y: layoutManager.extraLineFragmentRect.origin.y,
                    width: rect.width,
                    height: layoutManager.extraLineFragmentRect.height
                )
                /// Bool if the line should be highlighted
                let highlight = layoutManager.extraLineFragmentRect.minY == textView.currentParagraphRect?.minY
                drawLineNumber(
                    lineNumber,
                    inRect: markerRect,
                    highlight: highlight,
                    warning: false,
                    icon: ChordPro.Directive.emptyLine.details.icon
                )
                if highlight {
                    /// Set the current line of the cursor
                    textView.currentLine = Song.Section.Line(sourceLineNumber: lineNumber)
                }
            }
            /// Set the internals of the editor
            textView.parent?.runIntrospect(textView)

            /// Draw the number of the line
            func drawLineNumber(
                _ number: Int,
                inRect rect: NSRect,
                highlight: Bool,
                warning: Bool,
                icon: String
            ) {
                var attributes = Editor.rulerNumberStyle
                attributes[NSAttributedString.Key.font] = font
                switch highlight {
                case true:
                    context.setFillColor(Editor.highlightedBackgroundColor.cgColor)
                    context.fill(rect)
                    attributes[NSAttributedString.Key.foregroundColor] = NSColor.textColor
                case false:
                    attributes[NSAttributedString.Key.foregroundColor] = NSColor.secondaryLabelColor
                }
                /// Set the foreground color to red if we have a warning
                if warning {
                    attributes[NSAttributedString.Key.foregroundColor] = NSColor.red
                }
                /// Define the rect of the string
                var stringRect = rect
                /// Move the string a bit up
                stringRect.origin.y -= layoutManager.baselineNudge
                /// And a bit to the left to make space for the optional sf-symbol
                stringRect.size.width -= font.pointSize * 2
                /// Draw the line number
                let string = NSMutableAttributedString(string: "\(number) ")
                string.addAttributes(attributes, range: NSRange(location: 0, length: string.length))
                string.draw(in: stringRect)
                /// Draw the directive icon
                if let image = NSImage(systemSymbolName: icon, accessibilityDescription: "") {
                    let imageConfiguration = NSImage.SymbolConfiguration(pointSize: font.pointSize * 0.7, weight: .regular)
                    let imageAttachment = NSTextAttachment()
                    imageAttachment.image = image.withSymbolConfiguration(imageConfiguration)
                    /// Proper align it
                    if let imageSize = imageAttachment.image?.size {
                        imageAttachment.bounds = CGRect(
                            x: 0,
                            y: (font.capHeight - imageSize.height),
                            width: imageSize.width,
                            height: imageSize.height
                        )
                    }
                    let imageString = NSMutableAttributedString(attachment: imageAttachment)
                    /// Move it to the right of the line number
                    stringRect.origin.x += font.pointSize * 1.5
                    imageString.addAttributes(attributes, range: NSRange(location: 0, length: imageString.length))
                    imageString.draw(in: stringRect)
                }
            }
            textView.parent?.runIntrospect(textView)
        }
    }
}
