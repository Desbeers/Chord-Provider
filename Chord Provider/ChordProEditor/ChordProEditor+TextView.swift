//
//  ChordProEditor+TextView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {

    // MARK: The text view for the editor

    /// The text view for the editor
    class TextView: NSTextView {
        /// The delegate for the ChordProEditor
        var chordProEditorDelegate: ChordProEditorDelegate?
        /// The parent
        var parent: ChordProEditor?
        /// The parsed song lines
        var lines: [Song.Section.Line] = []
        /// The current line at the cursor
        var currentLine = Song.Section.Line()
        /// The optional arguments of the current directive
        var currentDirectiveArguments = ChordProParser.Arguments()
        /// The range of the current line
        var currentLineRange: NSRange = .init()
        /// The rect of the current paragraph
        var currentParagraphRect: NSRect?
        /// The optional double-clicked directive in the editor
        var clickedDirective: Bool = false
        /// The selected text in the editor
        var selectedText: String {
            if let swiftRange = Range(selectedRange(), in: string) {
                return String(string[swiftRange])
            }
            return ""
        }

        // MARK: Override functions

        /// Draw a background behind the current fragment
        /// - Parameter dirtyRect: The current rect of the editor
        override func draw(_ dirtyRect: CGRect) {
            guard let context = NSGraphicsContext.current?.cgContext else { return }
            /// Highlight the current selected paragraph
            if let currentParagraphRect {
                let lineRect = NSRect(
                    x: 0,
                    y: currentParagraphRect.origin.y,
                    width: dirtyRect.width,
                    height: currentParagraphRect.height
                )
                context.setFillColor(Editor.highlightedForegroundColor.cgColor)
                context.fill(lineRect)
            }
            super.draw(dirtyRect)
        }

        /// Handle double-click on directives to edit them
        /// - Parameter event: The mouse click event
        override func mouseDown(with event: NSEvent) {
            setFragmentInformation(selectedRange: selectedRange())
            if event.clickCount == 2, currentLine.directive.editable == true {
                clickedDirective = true
                parent?.runIntrospect(self)
            } else {
                clickedDirective = false
                return super.mouseDown(with: event)
            }
        }

        /// Set the selection to the characters in an array of ranges in response to user action
        override func setSelectedRange(
            _ charRange: NSRange,
            affinity: NSSelectionAffinity,
            stillSelecting stillSelectingFlag: Bool
        ) {
            super.setSelectedRange(charRange, affinity: affinity, stillSelecting: stillSelectingFlag)
            needsDisplay = true
            chordProEditorDelegate?.selectionNeedsDisplay()
        }

        // MARK: Custom functions

        /// Replace the whole text with a new text
        /// - Parameter text: The replacement text
        func replaceText(text: String) {
            let composeText = self.string as NSString
            self.insertText(text, replacementRange: NSRange(location: 0, length: composeText.length))
        }

        /// Get the parsed current line
        /// - Parameter lineNumber: The current line number
        /// - Returns: The parsed current line
        func getCurrentLine(lineNumber: Int) -> Song.Section.Line {
            var result = Song.Section.Line()
            if let line = lines.first(where: { $0.sourceLineNumber == lineNumber }) {
                result = line
            }
            return result
        }

        /// Set the fragment information
        /// - Parameter selectedRange: The current selected range of the text editor
        func setFragmentInformation(selectedRange: NSRange) {
            guard
                let textStorage = textStorage,
                let textContainer = textContainer,
                let layoutManager = layoutManager as? LayoutManager
            else {
                return
            }
            let composeText = textStorage.string as NSString
            let nsRange = composeText.paragraphRange(for: selectedRange)
            /// Set the rect of the current paragraph
            currentParagraphRect = layoutManager.boundingRect(forGlyphRange: nsRange, in: textContainer)
            /// Reduce the height of the rect if we have an extra line fragment and are on the last line with content
            if
                layoutManager.extraLineFragmentTextContainer != nil,
                NSMaxRange(nsRange) == composeText.length,
                nsRange.length != 0 {
                currentParagraphRect?.size.height -= layoutManager.lineHeight
            }
            /// Set the range of the current paragraph
            currentLineRange = nsRange
            /// Run introspect to inform the SwiftUI `View`
            parent?.runIntrospect(self)
        }
    }
}
