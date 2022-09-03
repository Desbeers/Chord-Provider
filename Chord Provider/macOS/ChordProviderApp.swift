//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The scene for the application
@main struct ChordProviderApp: App {
    @StateObject var mySongs = MySongs()
    @Environment(\.newDocument) private var newDocument
    var body: some Scene {
        /// The 'Song List' window
        WindowGroup("Song List") {
            FileBrowserView()
                .environmentObject(mySongs)
                .withHostingWindow({ window in
                    if let window = window?.windowController?.window {
                        window.level = .modalPanel
                        window.hidesOnDeactivate = true
                    }
                })
        }
        /// Make it sizable by the View frame
        .windowResizability(.contentSize)
        .defaultPosition(.topLeading)
        
        /// The actual 'song' window
        DocumentGroup(newDocument: ChordProDocument()) { file in
            ViewContent(document: file.$document, file: file.fileURL)
                .environmentObject(mySongs)
        }
        .defaultPosition(.center)
        .defaultSize(width: 800, height: 800)
        .commands {
            /// Toolbar commands
            ToolbarCommands()
        }
        
        /// Add Chord Provider to the Menu Bar
        MenuBarExtra("Chord Provider", systemImage: "guitars") {
            MenuBarExtraView()
                .environmentObject(mySongs)
        }
        .menuBarExtraStyle(.window)
    }
}

extension View {
    
    /// Find the NSWindow of the scene
    func withHostingWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

/// Find the NSWindow of the scene
private struct HostingWindowFinder: NSViewRepresentable {
    typealias NSViewType = NSView
    
    var callback: (NSWindow?) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) { }
}
