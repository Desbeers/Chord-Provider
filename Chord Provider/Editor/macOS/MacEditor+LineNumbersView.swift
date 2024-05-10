//
//  MacEditor+LineNumbersView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)

import AppKit

extension MacEditor {

    /// The line numbers view for the editor
    public class LineNumbersView: NSRulerView {

        // MARK: Init

        required override public init(scrollView: NSScrollView?, orientation: NSRulerView.Orientation) {
            super.init(scrollView: scrollView, orientation: orientation)
            clipsToBounds = true
        }

        required public init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Override functions

        override public func draw(_ dirtyRect: NSRect) {
            guard let context: CGContext = NSGraphicsContext.current?.cgContext else { return }
            /// Fill the background
            context.setFillColor(MacEditor.highlightedBackgroundColor.cgColor)
            context.fill(dirtyRect)
            /// Draw a border on the right
            context.setStrokeColor(MacEditor.highlightedForegroundColor.cgColor)
            context.setLineWidth(0.5)
            context.move(to: CGPoint(x: dirtyRect.width - 1, y: 0))
            context.addLine(to: CGPoint(x: dirtyRect.width - 1, y: dirtyRect.height))
            context.strokePath()
            /// - Note: Below usually gets called on super.draw(dirtyRect), but we're not calling it becasue that will override the background color
            drawHashMarksAndLabels(in: dirtyRect)
        }

        override public func drawHashMarksAndLabels(in rect: NSRect) {
            guard
                let textView: TextView = self.clientView as? TextView,
                let textContainer: NSTextContainer = textView.textContainer,
                let textStorage: NSTextStorage = textView.textStorage,
                let layout: NSLayoutManager = textView.layoutManager,
                let context: CGContext = NSGraphicsContext.current?.cgContext
            else {
                return
            }
            /// Get the current font
            let font: NSFont = textView.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
            /// Set the initial positions
            var positions = Positions()
            /// Get the scalar values of the text view content
            let scalars = textStorage.string.unicodeScalars

            /// Get the range of glyphs in the visible area of the text view
            let visibleGlyphRange = layout.glyphRange(forBoundingRect: textView.visibleRect, in: textContainer)
            let selectedLinePosition: CGFloat = textView.selectedLineRect?.origin.y ?? -1
            /// Count the newlines in range up to the visible range
            for index in 0..<visibleGlyphRange.location where scalars[index].isNewline {
                positions.lineNumber += 1
            }
            /// Set the context based on the Y-offset of the text view
            context.translateBy(x: 0, y: convert(NSPoint.zero, from: textView).y)
            /// Get the range of each line as we step through the visible Range, starting at the start of the visible range
            positions.lineStart = visibleGlyphRange.location
            /// Start drawing the line numbers
            for index in visibleGlyphRange.location..<visibleGlyphRange.location + visibleGlyphRange.length {
                positions.lineLength += 1
                if scalars[index].isNewline {
                    let lineRect = layout.boundingRect(
                        forGlyphRange: NSRange(location: positions.lineStart, length: positions.lineLength - 1),
                        in: textContainer
                    )
                    let markerRect = NSRect(
                        x: 0,
                        y: lineRect.origin.y,
                        width: rect.width,
                        height: lineRect.height
                    )
                    /// Draw the line number
                    drawLineNumber(
                        positions.lineNumber,
                        inRect: markerRect,
                        highlight: markerRect.origin.y == selectedLinePosition
                    )
                    /// Update the positions
                    positions.lineStart += positions.lineLength
                    positions.lineLength = 0
                    positions.lineNumber += 1
                    positions.lastLinePosition = markerRect.origin.y + lineRect.height
                }
            }
            /// Draw the last line number
            drawLineNumber(
                positions.lineNumber,
                inRect: NSRect(x: 0, y: positions.lastLinePosition, width: rect.width, height: rect.height),
                highlight: positions.lastLinePosition == selectedLinePosition
            )
            func drawLineNumber(_ number: Int, inRect rect: NSRect, highlight: Bool = false) {
                var attributes = MacEditor.rulerNumberStyle
                switch highlight {
                case true:
                    context.setFillColor(MacEditor.highlightedBackgroundColor.cgColor)
                    context.fill(rect)
                    attributes[NSAttributedString.Key.foregroundColor] = NSColor.textColor
                    attributes[NSAttributedString.Key.font] = NSFont.systemFont(ofSize: font.pointSize * 0.8, weight: .regular)
                case false:
                    attributes[NSAttributedString.Key.font] = NSFont.systemFont(ofSize: font.pointSize * 0.8, weight: .light)
                }
                var stringRect = rect
                /// Move the string a bit down
                stringRect.origin.y += (layout.defaultLineHeight(for: font) - font.pointSize * 0.8)
                /// And a bit to the left
                stringRect.size.width -= 3
                NSString(string: "\(number)").draw(in: stringRect, withAttributes: attributes)
            }
        }
    }
}

extension MacEditor.LineNumbersView {

    struct Positions {

        var lineNumber: Int = 1

        var lineStart: Int = 0

        var lineLength: Int = 0
        /// Y position of the last line
        var lastLinePosition: CGFloat = 0
    }
}

#endif
