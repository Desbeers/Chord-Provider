//
//  MacEditor+Wrapper.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)

import AppKit

extension MacEditor {

    /// The macOS editor
    ///
    /// A wrapper for
    /// - `NSScrollView`
    /// - `NSTextView`
    /// - `NSRulerView`
    public class Wrapper: NSView, NSTextStorageDelegate, NSTextViewDelegate, MacEditorDelegate, NSLayoutManagerDelegate {

        public var textView = TextView()

        private var storageDelegate: NSTextStorageDelegate?

        private var lineNumbers = LineNumbersView()


        override init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
            setup()
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }

        private func setup() {

            // MARK: Setup `NSScrollView`

            let scrollView = NSScrollView()
            scrollView.hasVerticalScroller   = true
            scrollView.hasHorizontalScroller = false
            scrollView.hasVerticalRuler      = true
            scrollView.rulersVisible         = true
            scrollView.borderType = .noBorder
            scrollView.autoresizingMask = [.width, .height]

            // MARK: Setup `TextView`

            /// - Note: The delegate of the `NSTextView will be set by the `ChordProEditor` init

            textView = TextView(frame: NSRect(origin: NSPoint.zero, size: scrollView.contentSize))
            textView.minSize = NSSize(width: 0, height: scrollView.contentSize.height)
            textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            textView.isVerticallyResizable = true
            textView.isHorizontallyResizable = false
            textView.autoresizingMask = .width
            textView.textContainer?.containerSize = NSSize(width: scrollView.contentSize.width, height: CGFloat.greatestFiniteMagnitude)
            textView.textContainer?.widthTracksTextView = true
            textView.macEditorDelegate = self
            textView.allowsUndo = true

            textView.textContainer?.replaceLayoutManager(LayoutManager())

            textView.layoutManager?.delegate = self

            // MARK: Setup `LineNumbersView`

            lineNumbers = LineNumbersView(frame: NSRect(x: 0, y: 0, width: 50, height: 0))
            lineNumbers.scrollView = scrollView
            lineNumbers.orientation = .verticalRuler
            lineNumbers.clientView = textView


            scrollView.verticalRulerView = lineNumbers
            scrollView.documentView = textView

            let textStorage = textView.textStorage

            textStorage?.delegate = self

            addSubview(scrollView)
        }

        public func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
            lineNumbers.needsDisplay = true
            storageDelegate?.textStorage?(textStorage, willProcessEditing: editedMask, range: editedRange, changeInLength: delta)
        }

        public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
            storageDelegate?.textStorage?(textStorage, didProcessEditing: editedMask, range: editedRange, changeInLength: delta)
        }

        override public func layout() {
            super.layout()
            lineNumbers.needsDisplay = true
        }

        func selectionNeedsDisplay() {
            lineNumbers.needsDisplay = true
        }

        // MARK: Layout Manager Delegate

        // swiftlint:disable:next function_parameter_count
        public func layoutManager(
            _ layoutManager: NSLayoutManager,
            shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<NSRect>,
            lineFragmentUsedRect: UnsafeMutablePointer<NSRect>,
            baselineOffset: UnsafeMutablePointer<CGFloat>,
            in textContainer: NSTextContainer,
            forGlyphRange glyphRange: NSRange
        ) -> Bool {
            let font: NSFont = textView.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)

            let fontLineHeight = layoutManager.defaultLineHeight(for: font)
            let lineHeight = fontLineHeight * MacEditor.lineHeightMultiple
            let baselineNudge = (lineHeight - fontLineHeight) * 0.5

            var rect = lineFragmentRect.pointee
            rect.size.height = lineHeight

            var usedRect = lineFragmentUsedRect.pointee
            usedRect.size.height = max(lineHeight, usedRect.size.height) // keep emoji sizes

            lineFragmentRect.pointee = rect
            lineFragmentUsedRect.pointee = usedRect
            baselineOffset.pointee += baselineNudge

            return true
        }
    }
}

#endif
