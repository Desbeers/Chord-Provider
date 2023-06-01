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
    /// Environment to open an existing document
    @Environment(\.openDocument) private var openDocument
    /// Open new windows
    @Environment(\.openWindow) private var openWindow
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
                    if let window = window?.windowController?.window {
                        fileBrowser.openWindows.append(
                            FileBrowserModel.WindowItem(windowID: window.windowNumber, songURL: file.fileURL)
                        )
                        window.orderFrontRegardless()
                    }
                }
        }
        .defaultSize(width: 800, height: 800)
        .defaultPosition(.center)
        .commands {
            /// Toolbar commands
            ToolbarCommands()
            CommandGroup(replacing: .newItem) {
                Button("New Song") {
                    newDocument(ChordProDocument())
                }
                .keyboardShortcut(KeyboardShortcut("N"))
                Button("Open Song") {
                    open()
                }
                .keyboardShortcut(KeyboardShortcut("O"))
                Button("New Song List") {
                    openWindow(id: "Main")
                }
                .keyboardShortcut(KeyboardShortcut("L"))
            }
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
    private func open() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.chordProDocument]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.runModal()
        if let url = panel.url {
            /// openDocument is very buggy; don't try to open a document when it is already open
            if let window = fileBrowser.openWindows.first(where: {$0.songURL == url}) {
                NSApp.window(withWindowNumber: window.windowID)?.makeKeyAndOrderFront(self)
            } else {
                Task {
                    try? await openDocument(at: url)
                }
            }
        }
    }
}
