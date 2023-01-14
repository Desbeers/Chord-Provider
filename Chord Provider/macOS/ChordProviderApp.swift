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
    /// Environment to open a new document
    @Environment(\.newDocument) private var newDocument
    /// The body of the `Scene`
    var body: some Scene {
        /// The 'Song List' window
        WindowGroup("Song List") {
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
                    if let window = window?.windowController?.window {
                        fileBrowser.openWindows.append(FileBrowserModel.WindowItem(windowID: window.windowNumber, songURL: file.fileURL))
                        window.orderFrontRegardless()
                    }
                }
        }
        .defaultSize(width: 800, height: 800)
        .defaultPosition(.center)
        .commands {
            /// Toolbar commands
            ToolbarCommands()
        }

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
