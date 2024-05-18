//
//  ChordProEditor+TextView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {

    /// The text view for the editor
    @Observable public class TextView: SWIFTTextView {

        /// The delegate for the ChordProEditor
        var chordProEditorDelegate: ChordProEditorDelegate?
        /// The optional curren directive
        var currentDirective: ChordPro.Directive?
        /// The current fragment of the cursor
        var currentFragment: NSTextLayoutFragment?
        /// The optional clicked fragment in the editor
        var clickedFragment: NSTextLayoutFragment?

        // MARK: Override functions

        override public func draw(_ dirtyRect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            if let fragment = currentFragment {
                let lineRect = CGRect(
                    x: 0,
                    y: fragment.layoutFragmentFrame.origin.y,
                    width: bounds.width,
                    height: fragment.layoutFragmentFrame.height
                )
                context.setFillColor(ChordProEditor.highlightedBackgroundColor.cgColor)
                context.fill(lineRect)
            }
            super.draw(dirtyRect)
        }

#if os(macOS)

        /// Handle double-click on directives
        override func mouseDown(with event: NSEvent) {
            if event.clickCount == 2, let currentDirective, ChordPro.Directive.editableDirectives.contains(currentDirective) {
                self.clickedFragment = currentFragment
            } else {
                super.mouseDown(with: event)
            }
        }
#endif

        // MARK: Private functions

        func setSelectedTextLayoutFragment(selectedRange: NSRange) {
#if os(macOS)
            /// - Note: `NSTextStorage` is an optional in macOS and not in iOS
            guard let textStorage = textStorage
            else { return }
#endif
            var selectedRange = selectedRange
            /// The last location of the document is ignored so reduce with 1 if we are at the last location
            selectedRange.location -= selectedRange.location == string.count ? 1 : 0
            guard
                let textLayoutManager = textLayoutManager,
                let textContentManager = textLayoutManager.textContentManager,
                let range = NSTextRange(range: selectedRange, in: textContentManager),
                let fragment = textLayoutManager.textLayoutFragment(for: range.location),
                let nsRange = NSRange(textRange: fragment.rangeInElement, in: textContentManager)
            else {
                currentDirective = nil
                currentFragment = nil
                return
            }
            /// Find the optional directive of the fragment
            var directive: ChordPro.Directive?
            textStorage.enumerateAttribute(.definition, in: nsRange) {values, _, _ in
                if let value = values as? ChordPro.Directive {
                    directive = value
                }
            }
            currentDirective = directive
            currentFragment = fragment
            setNeedsDisplay(bounds)
        }
    }
}
