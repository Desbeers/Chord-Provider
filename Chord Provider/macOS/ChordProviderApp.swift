//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI `Scene` for Chord Provider
@main struct ChordProviderApp: App {
    /// The ``FileBrowser``
    @StateObject var fileBrowser = FileBrowserModel()
    /// AppKit app delegate
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    /// The body of the `Scene`
    var body: some Scene {
        /// The 'Song List' window
        Window("Song List", id: "Main") {
            FileBrowserView()
                .environmentObject(fileBrowser)
        }
        /// Make it sizable by the View frame
        .windowResizability(.contentSize)
        .defaultPosition(.topLeading)

        /// The actual 'song' window
        DocumentGroup(newDocument: ChordProDocument()) { file in
            ContentView(document: file.$document, file: file.fileURL)
                .environmentObject(fileBrowser)
                .withHostingWindow { window in
                    /// Register the window unless we are browsing Versions
                    if !(file.fileURL?.pathComponents.contains("com.apple.documentVersions") ?? false), let window = window?.windowController?.window {
                        fileBrowser.openWindows.append(
                            FileBrowserModel.WindowItem(windowID: window.windowNumber, songURL: file.fileURL)
                        )
                        window.orderFrontRegardless()
                    }
                }
        }
        .defaultSize(width: 800, height: 800)
        .defaultPosition(.center)

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
