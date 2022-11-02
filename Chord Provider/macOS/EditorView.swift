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
        HighlightRule(pattern: Editor.chordsRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor.red)
        ]),
        HighlightRule(pattern: Editor.directiveRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor.controlAccentColor)
        ]),
        HighlightRule(pattern: Editor.directiveEmptyRegex!, formattingRules: [
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
            Spacer()
            Menu(
                content: {
                    Button(action: {
                        Editor.format(&document, directive: .comment, selection: selection, in: textView)
                    }, label: {
                        Label("Add a comment...", systemImage: "cloud")
                    })
                    Button(action: {
                        Editor.format(&document, directive: .chordDefine, selection: selection, in: textView)
                    }, label: {
                        Label("Define a chord...", systemImage: "music.note.list")
                    })
            }, label: {
                Label("More...", systemImage: "gear")
            })
            .menuStyle(.borderlessButton)
            .frame(width: 100)
        }
        .buttonStyle(EditorButton())
        .labelStyle(.titleAndIcon)
        .padding(10)
        .background(Color(nsColor: .windowBackgroundColor))
        .background(Color.primary.opacity(0.1))
        .cornerRadius(5)
        .padding(5)
    }
}

extension EditorView {
    
    /// The style for an editor button
    struct EditorButton: ButtonStyle {
        @State private var hovered = false
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(4)
                .background(hovered ? Color.primary.opacity(0.1) : Color.clear)
                .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                .onHover { isHovered in
                    self.hovered = isHovered
                }
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
                .animation(.easeInOut(duration: 0.2), value: hovered)
        }
    }
}
