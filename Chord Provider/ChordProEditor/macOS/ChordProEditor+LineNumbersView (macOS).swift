//
//  ChordProEditor+LineNumbersView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension ChordProEditor {
    // MARK: The line numbers view for the editor (macOS)

    /// The line numbers view for the editor
    public class LineNumbersView: NSRulerView {

        // MARK: Init

        /// Init the `NSRulerView`
        /// - Parameters:
        ///   - scrollView: The current `NSScrollView`
        ///   - orientation: The orientation of the `NSRulerView`
        required override public init(scrollView: NSScrollView?, orientation: NSRulerView.Orientation) {
            super.init(scrollView: scrollView, orientation: orientation)
            clipsToBounds = true
        }

        /// Init the `NSRulerView`
        /// - Parameter coder: The `NSCoder`
        required public init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Override functions

        /// Draw a background a a stroke on the right of the `NSRulerView`
        /// - Parameter dirtyRect: The current rect of the editor
        override public func draw(_ dirtyRect: NSRect) {
            guard
                let context: CGContext = NSGraphicsContext.current?.cgContext
            else {
                return
            }
            /// Fill the background
            context.setFillColor(ChordProEditor.highlightedBackgroundColor.cgColor)
            context.fill(bounds)
            /// Draw a border on the right
            context.setStrokeColor(ChordProEditor.highlightedForegroundColor.cgColor)
            context.setLineWidth(0.5)
            context.move(to: CGPoint(x: bounds.width - 1, y: 0))
            context.addLine(to: CGPoint(x: bounds.width - 1, y: bounds.height))
            context.strokePath()
            /// - Note: Below usually gets called on super.draw(dirtyRect), but we're not calling it because that will override the background color
            drawHashMarksAndLabels(in: bounds)
        }

        /// Draw marks and labels in the current `NSRulerView`
        /// - Parameter rect: The rect of the current `NSRulerView`
        override public func drawHashMarksAndLabels(in rect: NSRect) {
            guard
                let textView: TextView = self.clientView as? TextView,
                let textLayoutManager = textView.textLayoutManager,
                let textContentManager = textLayoutManager.textContentManager,
                let context: CGContext = NSGraphicsContext.current?.cgContext
            else {
                return
            }

            let font = textView.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)

            let relativePoint = self.convert(NSPoint.zero, from: textView)

            let selectedTextLayoutFragment = textView.currentFragment

            var paragraphs: [NSTextLayoutFragment] = []
            textLayoutManager.enumerateTextLayoutFragments(
                from: textContentManager.documentRange.location,
                options: [.ensuresLayout, .ensuresExtraLineFragment]
            ) { paragraph in
                paragraphs.append(paragraph)
                return true
            }

            var attributes = ChordProEditor.rulerNumberStyle
            attributes[NSAttributedString.Key.font] = font
            var number = 1
            var lineRect = CGRect()
            for paragraph in paragraphs {
                lineRect = paragraph.layoutFragmentFrame
                lineRect.size.width = rect.width
                lineRect.origin.x = 0
                lineRect.origin.y += relativePoint.y

                guard
                    let content = textView.textLayoutManager?.textContentManager,
                    let nsRange = NSRange(textRange: paragraph.rangeInElement, in: content)
                else {
                    print("error")
                    return
                }
                var directive: ChordPro.Directive?

                textView.textStorage?.enumerateAttribute(.definition, in: nsRange) {value, _, _ in
                    if let value = value as? ChordPro.Directive {
                        directive = value
                    }
                }

                if paragraph.layoutFragmentFrame == selectedTextLayoutFragment?.layoutFragmentFrame {
                    context.setFillColor(ChordProEditor.highlightedBackgroundColor.cgColor)
                    context.fill(lineRect)
                    attributes[NSAttributedString.Key.foregroundColor] = NSColor.textColor
                } else {
                    attributes[NSAttributedString.Key.foregroundColor] = ChordProEditor.highlightedForegroundColor
                }

                lineRect.origin.x = 5

                if let directive {
                    let imageAttachment = NSTextAttachment()
                    var imageConfiguration = NSImage.SymbolConfiguration(pointSize: font.pointSize * 0.8, weight: .light)
                    imageConfiguration = imageConfiguration.applying(.init(paletteColors: [.textColor, .systemGray]))
                    imageAttachment.image = NSImage(systemName: directive.details.icon).withSymbolConfiguration(imageConfiguration)
                    let  imageString = NSMutableAttributedString(attachment: imageAttachment)
                    let offset = (font.pointSize * 1.4) - font.pointSize
                    lineRect.origin.y += offset
                    imageString.draw(in: lineRect)
                    lineRect.origin.y -= offset
                }
                lineRect.size.width -= 10
                NSString(string: "\(number)").draw(in: lineRect, withAttributes: attributes)
                number += 1
            }
        }
    }
}
