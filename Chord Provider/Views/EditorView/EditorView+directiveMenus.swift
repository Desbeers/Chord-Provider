//
//  EditorView+directiveMenus.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// Menus with **ChordPro** directives
    @ViewBuilder
    @MainActor
    var directiveMenus: some View {
        @Bindable var appState = appState
        Group {
            Menu(
                content: {
                    ForEach(ChordPro.Directive.metaDataDirectives, id: \.self) { directive in
                        if connector.selectionState == .singleSelection {
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
            .disabled(connector.selectionState == .multipleSelections)
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
                        .disabled(connector.selectionState != .noSelection)
                    directiveButton(directive: .comment)
                },
                label: {
                    Label("More...", systemImage: "pencil")
                }
            )
            .disabled(connector.selectionState == .multipleSelections)
        }
        .menuStyle(.button)
        .disabled(connector.currentDirective != nil)
    }
}
