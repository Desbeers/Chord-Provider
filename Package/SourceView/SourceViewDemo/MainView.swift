//
//  MainView.swift
//  SourceViewDemo
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView
import CLibSpelling

/// The main `View` for the application
struct MainView: View {

    /// The `AdwaitaApp`
    var app: AdwaitaApp
    /// The `AdwaitaWindow`
    var window: AdwaitaWindow
    /// The state of the application
    @Binding var appState: AppState
    /// The main `View`
    var view: Body {
        OverlaySplitView(
            sidebar: {
                OptionsView(appState: $appState)
            }, content: {
                VStack {
                    SourceView.SearchOptions(bridge: $appState.editor)
                    ScrollView {
                        SourceView(
                            bridge: $appState.editor,
                            controller: appState.controller
                        )
                        /// Default language.
                        .language(.markdown)
                        .lineNumbers(appState.options.showLineNumbers)
                        .highlightCurrentLine(appState.options.highlightCurrentLine)
                        .wrapMode(appState.options.wrapLines ? .word : .none)
                        .spellCheck(appState.spelling)
                        .onTextChanged { _ in
                            appState.lastUpdate = Date.now
                            return []
                        }
                        .inspectOnAppear { storage in
                            setupSpelling(storage: storage)
                        }
                        .style("editor")
                        .css {
                            """
                            .editor.sourceview {
                                font-family: \(appState.monoSpaceFont ? "Monospace" : "Sans");
                                font-size: \(Double(appState.options.fontSize) / 100)em;
                            }
                            """
                        }
                        .vexpand()
                    }
                    Separator()
                    Text("Last update: \(appState.lastUpdate.formatted())")
                }
            }
        )
        .trailingSidebar()
        .topToolbar {
            HeaderBar {
                Button("Open File") {
                    appState.openFile.signal()
                }
            }
            end: {
                Menu(icon: .default(icon: .openMenu)) {
                    MenuButton("Find/Replace") {
                        appState.editor.showSearchBar.toggle()
                        if appState.editor.showSearchBar {
                            // Focus the search field
                            appState.editor.focusSearch.signal()
                        }
                    }
                    .keyboardShortcut("f".ctrl())
                    MenuButton("Quit", window: false) {
                        window.close()
                    }
                    .keyboardShortcut("q".ctrl())
                }
                .primary()
                .tooltip("Main Menu")
            }
            .headerBarTitle {
                WindowTitle(
                    subtitle: "Just a simple Demo",
                    title: "Source View Demo"
                )
            }
        }
        .onAppear {
            appState.editor.command = .openNewContent(welcomeText)
        }
        .fileImporter(
            open: $appState.openFile,
            filters: [
                .mimeType("text/plain", name: "Plain Text")
            ],
            acceptLabel: "Import"
        ) { fileURL in
            if let text = try? String(contentsOf: fileURL, encoding: .utf8) {
                appState.fileURL = fileURL
                appState.editor.command = .openNewContent(text)
                appState.controller.setLanguage(fileURL: fileURL)
            }
        }
    }

    private func setupSpelling(storage: ViewStorage) {
        guard let pointer = storage.opaquePointer else { return }
        let checker = spelling_checker_get_default()
        let textView: UnsafeMutablePointer<GtkTextView> = pointer.cast()
        let widget: UnsafeMutablePointer<GtkWidget> = pointer.cast()
        guard
              let buffer = gtk_text_view_get_buffer(textView),
              let adapter = spelling_text_buffer_adapter_new(
                  UnsafeMutableRawPointer(buffer).assumingMemoryBound(to: GtkSourceBuffer.self),
                  checker
              )
        else { return }
        gtk_text_view_set_extra_menu(textView, spelling_text_buffer_adapter_get_menu_model(adapter))
        gtk_widget_insert_action_group(widget, "spelling", adapter)
        spelling_text_buffer_adapter_set_enabled(adapter, appState.spelling ? 1 : 0)

        storage.fields["spelling"] = adapter

        // Get a notification when the language has changed,
        // because then we have to reset the previous spellcheck.
        storage.notify(name: "language", id: "language", pointer: checker) {
            spelling_text_buffer_adapter_invalidate_all(adapter)
        }
        // Get a notification when spellcheck is disabled.
        storage.notify(name: "enabled", id: "enabled", pointer: adapter) {
            appState.spelling = spelling_text_buffer_adapter_get_enabled(adapter) != 0
        }
    }
}

extension SourceView {

    func spellCheck(_ check: Bool = true) -> Self {
        modify { sourceView in
            sourceView.updateFunctions.append { storage, _, _ in
                guard let spelling = storage.fields["spelling"] as? OpaquePointer else {
                    return
                }
                spelling_text_buffer_adapter_set_enabled(spelling, check ? 1 : 0)
            }
        }
    }
}
