//
//  ChordProEditor+LayoutManager.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension ChordProEditor {

    // MARK: The layout manager for the editor

    /// The layout manager for the editor
    class LayoutManager: NSLayoutManager, NSLayoutManagerDelegate {
        /// The current font
        var font: NSFont {
            return self.textStorage?.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        }
        /// The line height of the current font
        var fontLineHeight: CGFloat {
            return self.defaultLineHeight(for: font)
        }
        /// The line height
        var lineHeight: CGFloat {
            let lineHeight = fontLineHeight * Editor.lineHeightMultiple
            return lineHeight
        }
        /// The nudge of the base line
        var baselineNudge: CGFloat {
            return (lineHeight - fontLineHeight) * 0.5
        }

        /// Takes care only of the last empty newline in the text backing store, or totally empty text views.
        override func setExtraLineFragmentRect(
            _ fragmentRect: NSRect,
            usedRect: NSRect,
            textContainer container: NSTextContainer
        ) {
            var fragmentRect = fragmentRect
            fragmentRect.size.height = lineHeight
            var usedRect = usedRect
            usedRect.size.height = lineHeight
            /// Call the super function
            super.setExtraLineFragmentRect(
                fragmentRect,
                usedRect: usedRect,
                textContainer: container
            )
        }

        // MARK: Layout Manager Delegate

        /// Customise the line fragment geometry before committing to the layout cache
        /// - Parameters:
        ///   - layoutManager: The current layout manager
        ///   - lineFragmentRect: The rect of the line fragment
        ///   - lineFragmentUsedRect: The used rect of the line fragment
        ///   - baselineOffset: The offset from the base line
        ///   - textContainer: The current text container
        ///   - glyphRange: The current glyp range
        /// - Returns: True
        func layoutManager(
            _ layoutManager: NSLayoutManager,
            shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<NSRect>,
            lineFragmentUsedRect: UnsafeMutablePointer<NSRect>,
            baselineOffset: UnsafeMutablePointer<CGFloat>,
            in textContainer: NSTextContainer,
            forGlyphRange glyphRange: NSRange
        ) -> Bool {

            var rect = lineFragmentRect.pointee
            rect.size.height = lineHeight

            var usedRect = lineFragmentUsedRect.pointee
            usedRect.size.height = max(lineHeight, usedRect.size.height)

            lineFragmentRect.pointee = rect
            lineFragmentUsedRect.pointee = usedRect
            baselineOffset.pointee += baselineNudge

            return true
        }
    }
}
