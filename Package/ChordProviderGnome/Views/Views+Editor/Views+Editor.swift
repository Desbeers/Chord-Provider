//
//  Views+Editor.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import SourceEditor

extension Views {

    /// The `View` for editing a song
    struct Editor: View {

        /// The state of the application
        @Binding var appState: AppState
        /// Confirmation for cleanup
        @State private var confirmCleanup: Bool = false
        /// The body of the `View`
        var view: Body {
            VStack {
                Inserts(appState: $appState)
                    .padding(5)
                    .halign(.center)
                EditorSearch(controller: appState.controller)
                Separator()
                HStack {
                    ScrollView {
                        EditorView(
                            controller: appState.controller
                        )
                        .onTextChanged { content in
                            return appState.updateSong(content: content)
                        }
                        .onLineChanged {
                            appState.setCurrentLine()
                        }
                        .onTripleClick {
                            let directive = appState.currentLine.directive
                            if let directive, directive.editable {
                                appState.scene.handleDirective =
                                appState.currentLine.directive
                                appState.scene.showEditDirectiveDialog = true
                            }
                        }
                        // .onSchemeChanged {
                        //     print("UPDATE CSS FOR CHORDPROVIDER")
                        //     appState.setStyle()
                        // }
                        .innerPadding(10, edges: .all)
                        .lineNumbers(appState.settings.editor.showLineNumbers)
                        .wrapMode(appState.settings.editor.wrapLines ? .word : .none)
                        .highlightCurrentLine(true)
                        .language(.constant(.chordpro))
                        .spelling($appState.settings.editor.spelling)
                        .scheme($appState.settings.editor.scheme)
                        .vexpand()
                        .style(.editor)
                        .focus($appState.scene.focusEditor)
                    }
                    .hexpand()
                    if appState.settings.editor.showMiniMap {
                        Separator()
                        EditorMap(controller: appState.controller)
                    }
                }
                Separator()
                    .bottomToolbar(visible: appState.settings.core.showWarnings) {
                        lineInfo
                    }
            }
            .card()
            .padding()
            .dialog(visible: $appState.scene.showEditDirectiveDialog) {
                let errors = appState.currentLine.warnings.compactMap(\.level).contains { $0 == .error }
                if errors {
                    errorMessage
                } else {
                    switch appState.scene.handleDirective {
                    case .define, .defineGuitar, .defineGuitalele, .defineUkulele:
                        Views.Editor.DefineChord(appState: $appState)
                    default:
                        Edit(appState: $appState)
                    }
                }
            }
        }
        /// The `View` for the error message
        var errorMessage: AnyView {
            VStack(spacing: 10) {
                let error = appState.currentLine.warnings.compactMap(\.message).joined(separator: "\n")
                Views.ErrorMessage(error: ChordProviderError.directiveNotEditable(error: error))
                Button("OK") {
                    appState.scene.showEditDirectiveDialog = false
                }
                .halign(.center)
            }
            .padding()
            .topToolbar {
                HeaderBar.empty()
                    .headerBarTitle {
                        WindowTitle(
                            subtitle: "Directive not editable",
                            title: "\(appState.scene.handleDirective?.details.label ?? "Error")"
                        )
                    }
            }
        }
        /// The `View` with line information
        var lineInfo: AnyView {
            HStack {
                Text("Line \(appState.currentLine.sourceLineNumber)")
                    .frame(maxWidth: 120)
                    .halign(.start)
                    .padding()
                ScrollView {
                    Text(appState.currentLine.warnings.map(\.message).joined(separator: "\n"))
                        .useMarkup()
                        .halign(.start)
                        .hexpand()
                }
                Button("Cleanup") {
                    confirmCleanup.toggle()
                }
                .padding()
                .insensitive(!appState.song.hasWarnings)
                .halign(.end)
                .valign(.center)
                .alertDialog(
                    visible: $confirmCleanup,
                    heading: "Cleanup",
                    body: "Are you sure you want to cleanup the song?",
                    id: "cleanup-dialog"
                ) {
                    Text("You can always undo this.")
                }
                .response("Cancel", role: .none) {
                    /// Nothing to do
                }
                .response("Cleanup", appearance: .suggested, role: .default) {
                    appState.controller.command(
                        .replaceAllText(
                            appState.song.allLines.map(\.sourceParsed).joined(separator: "\n")
                        )
                    )
                }
                Toggle(icon: .default(icon: .sidebarShowRight), isOn: $appState.settings.editor.showMiniMap)
                    .tooltip("Show Mini Map")
                    .valign(.center)
                    .padding(.trailing)
            }
            .style(.caption)
        }
    }
}
