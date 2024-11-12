//
//  ChordProEditor+LineNumbersView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
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
            context.setFillColor(ChordProEditor.highlightedBackgroundColor.cgColor)
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

        override func drawHashMarksAndLabels(in rect: NSRect) {
            guard
                let textView: TextView = self.clientView as? TextView,
                let textContainer: NSTextContainer = textView.textContainer,
                let textStorage: NSTextStorage = textView.textStorage,
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
            lineNumber += ChordProEditor.newLineRegex.numberOfMatches(
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
                    /// Bool if the line contains a warning
                    let warning = textView.log.map(\.lineNumber).contains(lineNumber)
                    /// Check if the paragraph contains a directive
                    var directive: ChordProDirective?
                    textStorage.enumerateAttribute(.directive, in: nsRange) {values, _, _ in
                        if let value = values as? String, textView.directives.map(\.directive).contains(value) {
                            directive = textView.directives.first { $0.directive == value }
                        }
                    }
                    if warning, directive == nil {
                        directive = ChordProDocument.warningDirective
                    }
                    /// Draw the line number
                    drawLineNumber(
                        lineNumber,
                        inRect: markerRect,
                        highlight: highlight,
                        warning: warning,
                        directive: directive
                    )
                    if highlight {
                        /// Set the current line number of the cursor
                        textView.currentLineNumber = lineNumber
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
                drawLineNumber(lineNumber, inRect: markerRect, highlight: highlight, warning: false, directive: nil)
            }
            /// Set the internals of the editor
            textView.parent?.runIntrospect(textView)

            /// Draw the number of the line
            func drawLineNumber(_ number: Int, inRect rect: NSRect, highlight: Bool, warning: Bool, directive: ChordProDirective?) {
                var attributes = ChordProEditor.rulerNumberStyle
                attributes[NSAttributedString.Key.font] = font
                switch highlight {
                case true:
                    context.setFillColor(ChordProEditor.highlightedBackgroundColor.cgColor)
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
                /// Draw the optional directive icon
                if let directive = directive, let image = NSImage(systemSymbolName: directive.icon, accessibilityDescription: directive.label) {
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

            /// Get optional directive argument inside the range
            func getDirectiveArgument(nsRange: NSRange) -> String? {
                var string: String?
                textStorage.enumerateAttribute(.directiveArgument, in: nsRange) {values, _, _ in
                    if let value = values as? String {
                        string = value.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
                return string
            }
            textView.parent?.runIntrospect(textView)
        }
    }
}
