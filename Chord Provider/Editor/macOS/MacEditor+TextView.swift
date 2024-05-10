//
//  MacEditor+TextView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)

import AppKit

extension MacEditor {

    /// The text view for the editor
    public class TextView: NSTextView {

        var macEditorDelegate: MacEditorDelegate?

        var selectedLineRect: NSRect? {
            guard
                let layout = layoutManager,
                let container = textContainer,
                let text = textStorage
            else {
                return nil
            }

            if selectedRange().length > 0 { return nil }

            return layout.boundingRect(forGlyphRange: text.rangeOfLineAtLocation(selectedRange().location), in: container)
        }

        // MARK: Init

        override init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
        }

        override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
            super.init(frame: frameRect, textContainer: container)
        }

        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Override functions

        /// Always return false, we'll draw the background ourselves
        /// - Note: True to cause the receiver to fill its background with the background color
        override public var drawsBackground: Bool {
            get { false }
            set {}
        }

        override public func draw(_ dirtyRect: NSRect) {
            guard let context = NSGraphicsContext.current?.cgContext else { return }
            if let textRect = selectedLineRect {
                let lineRect = NSRect(x: 0, y: textRect.origin.y, width: dirtyRect.width, height: textRect.height)
                context.setFillColor(MacEditor.highlightedBackgroundColor.cgColor)
                context.fill(lineRect)
            }
            super.draw(dirtyRect)
        }

        /// Sets the selection to the characters in an array of ranges in response to user action
        override public func setSelectedRange(_ charRange: NSRange, affinity: NSSelectionAffinity, stillSelecting stillSelectingFlag: Bool) {
            super.setSelectedRange(charRange, affinity: affinity, stillSelecting: stillSelectingFlag)
            needsDisplay = true
            macEditorDelegate?.selectionNeedsDisplay()
        }
    }
}

#endif
