//
//  MainView.swift
//  SourceEditorDemo
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import SourceEditor
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
        HStack {
            VStack {
                EditorSearch(controller: appState.controller)
                HStack {
                    ScrollView {
                        EditorView(controller: appState.controller)
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
                        .innerPadding(10, edges: .all)
                        .style("editor")
                        .css {
                            """
                            .editor.sourceview {
                                font-family: \(appState.options.monoSpaceFont ? "Monospace" : "Sans");
                                font-size: \(Double(appState.options.fontSize) / 100)em;
                            }
                            """
                        }
                        .hexpand()
                    }
                    .vexpand()
                    if appState.options.showMiniMap {
                        Box {
                            Separator()
                            EditorMap(controller: appState.controller)
                        }
                        .transition(.overLeft)
                    }
                }
            }
            OptionsView(appState: $appState)
                .frame(minWidth: 200)
                .style("source-view-options")
                .css {
                    let colors = appState.bridge.css(colorfull: appState.options.colorfullWindow)
                    return """
                    \(colors)
                    .boxed-list {
                        background: none;
                        box-shadow: none;
                    }
                    """
                }
        }
        .topToolbar {
            HeaderBar {
                Button("New") {
                    appState.controller.command(.newFile("Welcome to your new file!"))
                }
                Button("Open") {
                    appState.openFile.signal()
                }
                Button("Save") {
                    appState.controller.command(.save())
                        // appState.controller.save() { result in
                        //     switch result {
                        //     case .success:
                        //         print("All fine")
                        //     case .failure(let error):
                        //         dump(error)
                        //     }
                        // }
                }
                Toggle(icon: .default(icon: .sidebarShowRight), isOn: $appState.options.showMiniMap)
                    .tooltip("Show Mini Map")
            }
            end: {
                Menu(icon: .default(icon: .openMenu)) {
                    MenuButton("Save") {
                        appState.controller.command(.save())
                            // appState.controller.save() { result in
                            //     switch result {
                            //     case .success:
                            //         print("All fine")
                            //     case .failure(let error):
                            //         dump(error)
                            //     }
                            // }
                    }
                    .enabled(appState.bridge.modified, "Save")
                    MenuButton("Find/Replace") {
                        appState.bridge.showSearchBar.toggle()
                        if appState.bridge.showSearchBar {
                            // Focus the search field
                            appState.bridge.focusSearch.signal()
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
                    subtitle: appState.fileURL?.lastPathComponent ?? "Just a simple Demo",
                    title: "Source Editor Demo"
                )
            }
        }
        .bottomToolbar {
            HStack {
                Text("Line \(appState.bridge.currentLineNumber)")
                    .halign(.start)
                    .hexpand()
                Text(appState.bridge.modified ? "Modified" : "")
                Text("Last text update: \(appState.lastUpdate.formatted(date: .omitted, time: .standard))")
            }
            .style("caption")
            .padding()
        }
        //.bottomBarStyle(.raised)
        .onAppear {
            if appState.fileURL == nil {
                appState.controller.command(.newFile(welcomeText))
            }
        }
        .fileImporter(
            open: $appState.openFile,
            filters: [
                .mimeType("text/plain", name: "Plain Text")
            ],
            acceptLabel: "Import"
        ) { fileURL in
            appState.fileURL = fileURL
            appState.controller.command(
                .open(
                    fileURL,
                    completion: { result in
                        switch result {
                            case .success:
                            print("View Callback")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                )
            )
            //appState.controller.scheme
        }
    }
}
