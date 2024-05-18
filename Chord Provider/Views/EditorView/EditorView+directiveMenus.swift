//
//  EditorView+directiveMenus.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// Menus with **ChordPro** directives
    @ViewBuilder
    var directiveMenus: some View {
        @Bindable var appState = appState
        Group {
            Menu(
                content: {
                    ForEach(ChordPro.Directive.metaDataDirectives, id: \.self) { directive in
                        if connector.selection == .singleSelection {
                            directiveButton(directive: directive)
                        } else {
                            directiveSheetButton(directive: directive)
                        }
                    }
                },
                label: {
                    Label("Metadata", systemImage: "gear")
                }
            )
            .disabled(connector.selection == .multipleSelections)
            Menu(
                content: {
                    ForEach(ChordPro.Directive.environmentDirectives, id: \.self) { directive in
                        directiveButton(directive: directive)
                    }
                },
                label: {
                    Label("Environment", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
            )
            Menu(
                content: {
                    directiveSheetButton(directive: .define)
                        .disabled(connector.selection != .noSelection)
                    directiveButton(directive: .comment)
                },
                label: {
                    Label("More...", systemImage: "pencil")
                }
            )
            .disabled(connector.selection == .multipleSelections)
        }
        .menuStyle(.button)
        .disabled(connector.textView.currentDirective != nil)
    }
}
