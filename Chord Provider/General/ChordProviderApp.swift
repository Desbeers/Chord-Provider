//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import ChordProShared
import SwiftlyChordUtilities

/// SwiftUI `Scene` for **Chord Provider**
///
/// This is the starting point of the application
///
/// - Note: Each platform has its own `body`
@main struct ChordProviderApp: App {
    /// The observable ``FileBrowser`` class
    @State private var fileBrowser = FileBrowser()
    /// The state of the app
    @State private var appState = AppState(id: "Main")
    /// The ``AppDelegate`` class  for **Chord Provider**
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    /// The `openWindow` environment to open a new Window
    @Environment(\.openWindow) private var openWindow
    /// The body of the `Scene`
    ///
    /// - `Window`:  scene with a list of songs
    /// - `Window`: scene to export a folder of songs
    /// - `DocumentGroup` scene to open a single song
    /// - `MenuBarExtra` scene that shows a list with songs as well
    /// - `Settings` scene to open the settings Window
    var body: some Scene {

        // MARK: 'Song List' single window

        /// The 'Song List' window
        Window("Song List", id: AppSceneID.songListWindow.rawValue) {
            FileBrowserView()
                .environment(fileBrowser)
        }
        .keyboardShortcut("l")
        /// Make it sizeable by the View frame
        .windowResizability(.contentSize)
        .defaultPosition(.topLeading)
        .windowToolbarStyle(.unifiedCompact)

        // MARK: 'Export Folder' single window

        /// The 'Export Folder' window
        Window("Export Folder with Songs…", id: AppSceneID.exportFolderWindow.rawValue) {
            ExportFolderView()
                .frame(width: 400, height: 600)
                .environment(appState)
                .environment(fileBrowser)
        }
        .keyboardShortcut("e")
        /// Make it sizable by the View frame
        .windowResizability(.contentSize)
        .defaultPosition(.center)
        .windowToolbarStyle(.unifiedCompact)

        // MARK: 'Song' document window

        /// The actual 'song' window
        DocumentGroup(newDocument: ChordProDocument()) { file in
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
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Divider()
                Button("Export Folder with Songs…") {
                    openWindow(id: AppSceneID.exportFolderWindow.rawValue)
                }
            }
            CommandGroup(after: .importExport) {
                ExportSongView()
            }
            CommandGroup(after: .importExport) {
                PrintPDFView()
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
