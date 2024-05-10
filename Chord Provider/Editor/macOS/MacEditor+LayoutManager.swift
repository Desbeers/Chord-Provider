//
//  MacEditor+LayoutManager.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)

import AppKit

extension MacEditor {

    /// The layout manager for the editor
    class LayoutManager: NSLayoutManager {

        private var font: NSFont {
            return self.firstTextView?.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        }

        private var lineHeight: CGFloat {
            let fontLineHeight = self.defaultLineHeight(for: font)
            let lineHeight = fontLineHeight * MacEditor.lineHeightMultiple
            return lineHeight
        }

        /// Takes care only of the last empty newline in the text backing store, or totally empty text views.
        override func setExtraLineFragmentRect(
            _ fragmentRect: NSRect,
            usedRect: NSRect,
            textContainer container: NSTextContainer
        ) {
            /// This is only called when editing, and re-computing the
            /// `lineHeight` isn't that expensive, so no caching.
            let lineHeight = self.lineHeight
            var fragmentRect = fragmentRect
            fragmentRect.size.height = lineHeight
            var usedRect = usedRect
            usedRect.size.height = lineHeight
            /// Call the suer function
            super.setExtraLineFragmentRect(
                fragmentRect,
                usedRect: usedRect,
                textContainer: container
            )
        }
    }
}

#endif
