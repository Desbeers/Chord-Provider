//
//  Views+Editor.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import SourceView

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
                SearchOptions(appState: $appState)
                Separator()
                ScrollView {
                    SourceView(bridge: $appState.editor, controller: appState.controller, language: .chordpro)
                        .innerPadding(10, edges: .all)
                        .lineNumbers(appState.settings.editor.showLineNumbers)
                        .wrapMode(appState.settings.editor.wrapLines ? .word : .none)
                        .highlightCurrentLine(true)
                        .highlightSearchResult(appState.scene.showSearchBar)
                        .vexpand()
                        .style("editor")
                        .focus(appState.scene.focusEditor)
                }
                Separator()
                if appState.editor.coreSettings.showWarnings {
                    lineInfo
                        .transition(.coverUpDown)
                }
            }
            .card()
            .padding()
            .dialog(visible: $appState.editor.showEditDirectiveDialog) {
                let errors = appState.editor.currentLine.warnings?.compactMap(\.level).contains { $0 == .error} ?? false
                if errors {
                    errorMessage
                } else {
                    switch appState.editor.handleDirective {
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
                let error = appState.editor.currentLine.warnings?.compactMap(\.message).joined(separator: "\n")
                Views.ErrorMessage(error: ChordProviderError.directiveNotEditable(error: error ?? "Unnown Error"))
                Button("OK") {
                appState.editor.showEditDirectiveDialog = false
                }
                .halign(.center)
            }
            .padding()
            .topToolbar {
                HeaderBar.empty()
                    .headerBarTitle {
                        WindowTitle(
                            subtitle: "Directive not editable",
                            title: "\(appState.editor.handleDirective?.details.label ?? "Error")"
                        )
                    }
            }
        }
        /// The `View` with line information
        var lineInfo: AnyView {
            HStack {
                Text("Line \(appState.editor.currentLine.sourceLineNumber)")
                    .frame(maxWidth: 120)
                    .halign(.start)
                    .padding()
                ScrollView {
                    if let warnings = appState.editor.currentLine.warnings {
                        Text(warnings.map(\.message).joined(separator: "\n"))
                            .useMarkup()
                            .halign(.start)
                            .hexpand()
                    } else {
                        Text(" ")
                            .hexpand()
                    }
                }
                Button("Cleanup") {
                    confirmCleanup.toggle()
                }
                .padding()
                .insensitive(!appState.editor.song.hasWarnings)
                .halign(.end)
                .valign(.center)
                .alertDialog(
                    visible: $confirmCleanup,
                    heading: "Cleanup",
                    body: "Are you sure you want to cleanup the song?",
                    id: "cleanup-dialog",
                    extraChild: {
                        Text("You can always undo this.")
                    }
                )
                .response("Cancel", role: .none) {
                    /// Nothing to do
                }
                .response("Cleanup", appearance: .suggested, role: .default) {
                    appState.editor.command = .replaceAllText(
                        appState.editor.song.allLines.map(\.sourceParsed).joined(separator: "\n")
                    )
                }
            }
            .style(.caption)
        }
    }
}
