//
//  EditorView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import HighlightedTextEditor

/// The View with the `HighlightedTextEditor`
struct EditorView: View {
    /// The CordPro document
    @Binding var document: ChordProDocument
    /// The actuals NSTextView
    @State private var textView: NSTextView?
    /// The selected text in the editor
    @State var selection = NSRange()
    /// The highlight rules
    private let rules: [HighlightRule] = [
        HighlightRule(pattern: ChordPro.chordsRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor.red)
        ]),
        HighlightRule(pattern: ChordPro.directiveRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor.controlAccentColor)
        ]),
        HighlightRule(pattern: ChordPro.directiveEmptyRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor.controlAccentColor)
        ]),
        HighlightRule(pattern: NSRegularExpression.all, formattingRules: [
            TextFormattingRule(key: .font, value: NSFont(name: "Andale Mono", size: 16)!)
        ])
    ]
    /// The View
    var body: some View {
        VStack {
            toolbar
            editor
        }
    }
    /// The editor
    var editor: some View {
        HighlightedTextEditor(text: $document.text, highlightRules: rules)
        /// Below selector prevents the cursor from jumping while the SongView is updated
        /// It will also be passed to 'format' buttons
            .onSelectionChange { (range: NSRange) in
                selection = range
            }
        /// Below is needed to interact with the NSTextView
            .introspect(callback: { editor in
                if self.textView == nil {
                    Task { @MainActor in
                        self.textView = editor.textView
                    }
                }
            })
    }
    /// The Toolbar
    var toolbar: some View {
        HStack {
            Button(action: {
                Editor.format(&document, directive: .chorus, selection: selection, in: textView)
            }, label: {
                Label("Chorus", systemImage: "music.note.list")
            })
            Button(action: {
                Editor.format(&document, directive: .verse, selection: selection, in: textView)
            }, label: {
                Label("Verse", systemImage: "music.mic")
            })
            Menu(
                content: {
                    Button(action: {
                        Editor.format(&document, directive: .comment, selection: selection, in: textView)
                    }, label: {
                        Label("Add a comment...", systemImage: "cloud")
                    })
            }, label: {
                Label("Add metadata", systemImage: "gear")
            })

        }
        .labelStyle(.titleAndIcon)
        .padding()
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
