//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `Scene` for **Chord Provider**
@main struct ChordProviderApp: App {
    /// The observable ``FileBrowser`` class
    @State private var fileBrowser = FileBrowser.shared
    /// The state of the app
    @State private var appState = AppState.shared
    /// The ``AppDelegate`` class  for **Chord Provider**
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    /// The body of the `Scene`
    var body: some Scene {

        // MARK: 'Song' document window

        /// The actual 'song' window
        ///
        /// This is a dirty hack of the `DocumentGroup` scene.
        /// It will hijack the creation of a new empty document and shows an AppKit Window instead
        ///
        /// See the ``AppDelegate``. It seems to work fine but it should not be like this...
        ///
        /// - Note: When you create a new document and remove all text; the window will close and the AppKit window will appear.
        DocumentGroup(newDocument: ChordProDocument(text: appState.newDocumentContent)) { file in
            if file.fileURL == nil && file.document.text.isEmpty {
                ProgressView()
                    .withHostingWindow { window in
                        window?.alphaValue = 0
                        window?.close()
                        appDelegate.showNewDocumentView()
                    }
            } else {
                ContentView(document: file.$document, file: file.fileURL)
                    .environment(fileBrowser)
                    .environment(appState)
                /// Give the scene access to the document.
                    .focusedSceneValue(\.document, file)
                    .onDisappear {
                        Task { @MainActor in
                            if let index = fileBrowser.openWindows.firstIndex(where: { $0.fileURL == file.fileURL }) {
                                /// Mark window as closed
                                fileBrowser.openWindows.remove(at: index)
                            }
                        }
                    }
                    .withHostingWindow { window in
                        /// Register the window unless we are browsing Versions
                        /// - Note: More dirty hacks
                        if
                            !(file.fileURL?.pathComponents.contains("com.apple.documentVersions") ?? false),
                            let window = window?.windowController?.window {
                            fileBrowser.openWindows.append(
                                NSWindow.WindowItem(
                                    windowID: window.windowNumber,
                                    fileURL: file.fileURL
                                )
                            )
                        }
                    }
                    .onChange(of: file.fileURL) { oldURL, newURL in
                        if let index = fileBrowser.openWindows.firstIndex(where: { $0.fileURL == oldURL }) {
                            fileBrowser.openWindows[index].fileURL = newURL
                        }
                    }
                    .task {
                        appDelegate.closeWelcomeWindow()
                        /// Reset the new content
                        appState.newDocumentContent = ""
                    }
            }
        }
        .commands {
#if DEBUG
            CommandGroup(after: .appInfo) {
                Divider()
                ResetApplicationButtonView()
            }
#endif
            CommandGroup(after: .importExport) {
                ExportSongView()
                    .keyboardShortcut("e")
            }
            CommandGroup(after: .importExport) {
                PrintPDFView()
                    .keyboardShortcut("p")
            }
            CommandGroup(after: .textEditing) {
                MenuButtonsView()
                    .environment(appState)
            }
            CommandGroup(replacing: .help) {
                HelpButtonsView()
            }
        }
        .defaultSize(width: 1000, height: 800)
        .defaultPosition(.center)

        // MARK: 'Song List' menu bar extra

        /// Add Chord Provider to the Menu Bar
        MenuBarExtra("Chord Provider", systemImage: "guitars") {
            FileBrowserView()
                .environment(fileBrowser)
                .withHostingWindow { window in
                    fileBrowser.menuBarExtraWindow = window
                }
        }
        .menuBarExtraStyle(.window)

        // MARK: Settings

        /// The settings window
        Settings {
            SettingsView()
                .environment(appState)
                .environment(fileBrowser)
                .frame(width: 340, height: 480)
        }
    }

    // MARK: Scene Windows

    /// The window scenes we can open on macOS
    ///
    /// - Note: The ID of a scene we set on on a `Window` or to open a `Window` in the environment is a `String`.
    /// This is is asking for troubles, so I use an `enum` instead.
    private enum AppSceneID: String {
        /// A scene with a list of songs
        case songListWindow
        /// A scene to export a folder of songs
        case exportFolderWindow
    }
}
