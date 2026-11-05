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
                        .spelling($appState.options.spelling)
                        .scheme($appState.options.scheme)
                        .onTextChanged { _ in
                            appState.lastUpdate = Date.now
                            return []
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
                    HStack {
                        Text("Line \(appState.editor.currentLineNumber)")
                            .halign(.start)
                            .hexpand()
                        Text(appState.options.scheme)
                        Text("Last update: \(appState.lastUpdate.formatted())")
                    }
                    .padding()
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
}
