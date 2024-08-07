//
//  ChordProEditor.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

// MARK: The ChordPro editor

/// SwiftUI `NSViewRepresentable` for the **ChordPro** editor
public struct ChordProEditor: NSViewRepresentable {
    /// The `Binding` to the text of the document
    @Binding var text: String
    /// The ``Settings`` for the editor
    let settings: Settings
    /// All the directives we know about
    let directives: [ChordProDirective]
    /// The 'introspect' callback with the editor``Internals``
    private(set) var introspect: IntrospectCallback?

    /// Init the **ChordPro** editor
    /// - Parameters:
    ///   - text: The `Binding` to the text of the document
    ///   - settings: The ``Settings`` for the editor
    ///   - directives: All the directives we know about
    public init(text: Binding<String>, settings: Settings, directives: [ChordProDirective]) {
        self._text = text
        self.settings = settings
        self.directives = directives
    }
    /// Make a `coordinator` for the `NSViewRepresentable`
    /// - Returns: A `coordinator`
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    /// Make the `View`
    /// - Parameter context: The context
    /// - Returns: The wrapped editor
    public func makeNSView(context: Context) -> Wrapper {
        let wrapper = Wrapper()
        wrapper.delegate = context.coordinator
        wrapper.textView.directives = directives
        wrapper.textView.parent = self
        wrapper.textView.font = settings.font
        wrapper.textView.string = text
        /// Wait for next cycle and set the textview as first responder
        Task { @MainActor in
            highlightText(textView: wrapper.textView)
            wrapper.textView.selectedRanges = [NSValue(range: NSRange())]
            wrapper.textView.window?.makeFirstResponder(wrapper.textView)
        }
        return wrapper
    }
    /// Update the `View`
    /// - Parameters:
    ///   - view: The wrapped editor
    ///   - context: The context
    public func updateNSView(_ wrapper: Wrapper, context: Context) {
        /// Update the text in the TextView when it is changed from *outside*; like when adding the example song
        if context.coordinator.task == nil, self.text != wrapper.textView.string {
            wrapper.textView.string = text
            highlightText(textView: wrapper.textView)
        }
        /// Update the settings when changed
        if context.coordinator.parent.settings != settings {
            context.coordinator.parent = self
            highlightText(textView: wrapper.textView)
            wrapper.textView.setFragmentInformation(selectedRange: wrapper.textView.selectedRange())
            wrapper.textView.chordProEditorDelegate?.selectionNeedsDisplay()
        }
    }
    /// Highlight the text in the editor
    /// - Parameters:
    ///   - textView: The current ``TextView``
    ///   - range: The range to highlight
    @MainActor func highlightText(textView: NSTextView, range: NSRange? = nil) {
        ChordProEditor.highlight(
            view: textView,
            settings: settings,
            range: range ?? NSRange(location: 0, length: text.utf16.count),
            directives: directives
        )
    }
}

// MARK: Introspect extensions

extension ChordProEditor {

    public func introspect(callback: @escaping IntrospectCallback) -> Self {
        var editor = self
        editor.introspect = callback
        return editor
    }

    @MainActor func runIntrospect(_ view: TextView) {
        guard let introspect = introspect else { return }
        /// The calculated file name of the song
        var songFileName: String {
            var result: [String] = []
                if let songSubtitle = view.songSubtitle {
                    result.append(songSubtitle)
                }
                result.append(view.songTitle)
            return result.joined(separator: " - ")
        }
        /// Set the internals of the editor
        let internals = Internals(
            directive: view.currentDirective,
            directiveArgument: view.currentDirectiveArgument,
            directiveRange: view.currentDirectiveRange,
            clickedDirective: view.clickedDirective,
            selectedRange: view.selectedRange(),
            textView: view,
            songFileName: songFileName
        )
        introspect(internals)
    }
}

public typealias IntrospectCallback = (_ editor: ChordProEditor.Internals) -> Void
