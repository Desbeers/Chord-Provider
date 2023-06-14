//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `Scene` for Chord Provider
@main struct ChordProviderApp: App {
    /// The ``FileBrowserModel``
    @StateObject var fileBrowser = FileBrowserModel()
    /// AppKit app delegate
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    /// The body of the `Scene`
    var body: some Scene {

        // MARK: 'Song List' single window

        /// The 'Song List' window
        Window("Song List", id: "Main") {
            FileBrowserView()
                .environmentObject(fileBrowser)
        }
        .keyboardShortcut("l")
        /// Make it sizable by the View frame
        .windowResizability(.contentSize)
        .defaultPosition(.topLeading)
        .windowToolbarStyle(.unifiedCompact)

        // MARK: 'Song' document window

        /// The actual 'song' window
        DocumentGroup(newDocument: ChordProDocument()) { file in
            ContentView(document: file.$document, file: file.fileURL)
                .environmentObject(fileBrowser)
                .withHostingWindow { window in
                    /// Register the window unless we are browsing Versions
                    if !(file.fileURL?.pathComponents.contains("com.apple.documentVersions") ?? false), let window = window?.windowController?.window {
                        fileBrowser.openWindows.append(
                            NSWindow.WindowItem(
                                windowID: window.windowNumber,
                                fileURL: file.fileURL
                            )
                        )
                    }
                }
                .onChange(of: file.fileURL) { [file] newURL in
                    if let index = fileBrowser.openWindows.firstIndex(where: {$0.fileURL == file.fileURL}) {
                        fileBrowser.openWindows[index].fileURL = newURL
                    }
                }
        }
        .defaultSize(width: 1000, height: 800)
        .defaultPosition(.center)

        // MARK: 'Song List' menu bar extra

        /// Add Chord Provider to the Menu Bar
        MenuBarExtra("Chord Provider", systemImage: "guitars") {
            FileBrowserView()
                .environmentObject(fileBrowser)
                .withHostingWindow { window in
                    fileBrowser.menuBarExtraWindow = window
                }
        }
        .menuBarExtraStyle(.window)
    }
}

/// AppDelegate for Chord Provider
class AppDelegate: NSObject, NSApplicationDelegate {
    /// Don't terminate when the last Chord Provider window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
