//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyFolderUtilities
import SwiftlyChordUtilities

/// SwiftUI `Scene` for Chord Provider
@main struct ChordProviderApp: App {
    /// The FileBrowser model
    @State private var fileBrowser = FileBrowser()
    /// The welcome view setting
    @AppStorage("hideWelcome") var hideWelcome: Bool = true
    /// Chord Display Options
    @State private var chordDisplayOptions = ChordDisplayOptions(defaults: ChordProviderSettings.defaults)
    /// The state of the app
    @State private var appState = AppState()

#if os(macOS)

    // MARK: macOS

    /// AppKit app delegate
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    /// Open new windows
    @Environment(\.openWindow) var openWindow
    /// The body of the `Scene`
    var body: some Scene {

        // MARK: 'Song List' single window

        /// The 'Song List' window
        Window("Song List", id: "Main") {
            FileBrowserView()
                .environment(fileBrowser)
        }
        .keyboardShortcut("l")
        /// Make it sizable by the View frame
        .windowResizability(.contentSize)
        .defaultPosition(.topLeading)
        .windowToolbarStyle(.unifiedCompact)

        // MARK: 'Export Folder' single window

        /// The 'Export Folder' window
        Window("Export Folder with Songs…", id: "Export") {
            ExportFolderView()
                .environment(fileBrowser)
                .environment(chordDisplayOptions)
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
                .environment(chordDisplayOptions)
                .environment(appState)
            /// Give the scene access to the document.
                .focusedSceneValue(\.document, file.document)
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
                    if !(file.fileURL?.pathComponents.contains("com.apple.documentVersions") ?? false),
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
                    openWindow(id: "Export")
                }
            }
            CommandGroup(after: .importExport) {
                ExportSongView()
            }
            CommandGroup(after: .importExport) {
                PrintSongView()
            }
            CommandGroup(replacing: .help) {
                if let url = URL(string: "https://github.com/Desbeers/Chord-Provider") {
                    Link(destination: url) {
                        Text("Chord Provider on GitHub")
                    }
                }
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

        Settings {
            SettingsView()
                .environment(chordDisplayOptions)
                .environment(fileBrowser)
        }
    }
#endif

#if os(iOS)

    // MARK: iPadOS

    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            ContentView(document: file.$document, file: file.fileURL)
                .environment(chordDisplayOptions)
                .environment(fileBrowser)
                .environment(appState)
                .task {
                    if hideWelcome == false {
                        UserDefaults.standard.removeObject(forKey: "welcome")
                    }
                }
                .toolbarBackground(
                    Color.accent.opacity(0.4),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
#endif

#if os(visionOS)

    // MARK: visiondOS

    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            ContentView(document: file.$document, file: file.fileURL)
                .environment(appState)
                .environment(chordDisplayOptions)
                .environment(fileBrowser)
        }
    }
#endif
}

#if os(macOS)
/// AppDelegate for Chord Provider
class AppDelegate: NSObject, NSApplicationDelegate {
    /// Don't terminate when the last Chord Provider window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
#endif
