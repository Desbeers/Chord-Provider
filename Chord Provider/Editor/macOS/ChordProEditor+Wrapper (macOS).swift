//
//  ChordProEditor+Wrapper (macOS).swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)

import AppKit

extension ChordProEditor {

    /// The macOS editor
    ///
    /// A wrapper for
    /// - `NSScrollView`
    /// - `NSTextView`
    /// - `NSRulerView`
    public class Wrapper: NSView, NSTextLayoutManagerDelegate, ChordProEditorDelegate {

        public var textView = TextView()

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

            let contentSize = scrollView.contentSize
            let textContentStorage = NSTextContentStorage()
            let textLayoutManager = NSTextLayoutManager()
            /// Allow multiple selections
            /// - Note: This does not work, buug??
            textLayoutManager.textSelectionNavigation.allowsNonContiguousRanges = true
            textContentStorage.addTextLayoutManager(textLayoutManager)

            let textContainer = NSTextContainer(size: scrollView.frame.size)
            textContainer.widthTracksTextView = true
            textContainer.containerSize = NSSize(
                width: contentSize.width,
                height: CGFloat.greatestFiniteMagnitude
            )
            textLayoutManager.textContainer = textContainer

            /// - Note: The delegate of the `NSTextView will be set by the `ChordProEditor` init

            textView = TextView(frame: .zero, textContainer: textContainer)
            textView.minSize = NSSize(width: 0, height: scrollView.contentSize.height)
            textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            textView.isVerticallyResizable = true
            textView.isHorizontallyResizable = false
            textView.autoresizingMask = .width
            textView.chordProEditorDelegate = self
            textView.allowsUndo = true
            textView.textContainerInset = .init(width: 4, height: 0)
            textView.drawsBackground = false

            // MARK: Setup `LineNumbersView`

            lineNumbers.scrollView = scrollView
            lineNumbers.orientation = .verticalRuler
            lineNumbers.clientView = textView
            lineNumbers.ruleThickness = 40

            scrollView.verticalRulerView = lineNumbers
            scrollView.documentView = textView

            addSubview(scrollView)
        }

        // MARK: MacEditorDelegate

        func selectionNeedsDisplay() {
            lineNumbers.needsDisplay = true
        }
    }
}

#endif
