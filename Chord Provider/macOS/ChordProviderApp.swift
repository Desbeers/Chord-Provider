//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The scene for the application
@main struct ChordProviderApp: App {
    @StateObject var fileBrowser = FileBrowser()
    @Environment(\.newDocument) private var newDocument
    var body: some Scene {
        /// The 'Song List' window
        WindowGroup("Song List") {
            FileBrowserView()
                .environmentObject(fileBrowser)
                .withHostingWindow { window in
                    if let window = window?.windowController?.window {
                        window.level = .modalPanel
                        window.hidesOnDeactivate = true
                    }
                }
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
                        fileBrowser.openWindows.append(FileBrowser.WindowItem(windowID: window.windowNumber, songURL: file.fileURL))                        
                        let padding = CGFloat(fileBrowser.openWindows.count * 40)
                        window.setPosition(vertical: .top, horizontal: .center, padding: padding)
                        window.orderFrontRegardless()
                    }
                }
        }
        .defaultSize(width: 800, height: 800)
        .commands {
            /// Toolbar commands
            ToolbarCommands()
        }
        
        /// Open 'All Chords'' Windows
        WindowGroup("All Chords", for: Window.self) { _ in
            AllChordsView()
            .withHostingWindow { window in
                if let window = window?.windowController?.window {
                    window.setPosition(vertical: .center, horizontal: .center, padding: 0)
                }
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
}

extension ChordProviderApp {
    
    /// The kind of Windows Chord Provider can open
    enum Window: String, Codable {
        case allChords = "All Chords"
    }
}
