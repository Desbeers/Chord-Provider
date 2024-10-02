//
//  AppDelegateModel.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The AppDelegate for **Chord Provider**
///
/// Is is a bit sad the we have to go trough all loops just to get a good experience for a true mac application nowadays
/// SwiftUI is great and fun, also on macOS, unless... It is more than 'Hello World!" in a document...
@Observable class AppDelegateModel: NSObject, NSApplicationDelegate {

    /// Close all windows except the menuBarExtra
    /// - Note: Part of the `DocumentGroup` dirty hack; don't show the NSOpenPanel
    func applicationDidFinishLaunching(_ notification: Notification) {
        for window in NSApp.windows where window.styleMask.rawValue != 0 {
            window.close()
        }
        showNewDocumentView()
    }

    /// Show the `NewDocumentView` instead of the NSOpenPanel when there are no documents open
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        switch flag {
        case true:
            return true
        case false:
            showNewDocumentView()
            return false
        }
    }

    /// Don't terminate when the last **Chord Provider** window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    /// Default style mask
    let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable, .titled, .fullSizeContentView]

    /// The controller for the `WelcomeView` window
    private var welcomeViewController: NSWindowController?
    /// Show the `WelcomeView` window in Appkit
    @MainActor func showNewDocumentView() {
        if welcomeViewController == nil {
            let window = createWindow(title: "Chord Provider")
            window.styleMask.remove(.titled)
            window.isMovableByWindowBackground = true
            window.contentView = NSHostingView(rootView: WelcomeView(appDelegate: self))
            window.backgroundColor = NSColor.clear
            window.center()
            welcomeViewController = NSWindowController(window: window)
        }
        /// Update the recent files list
        AppStateModel.shared.recentFiles = NSDocumentController.shared.recentDocumentURLs
        welcomeViewController?.showWindow(welcomeViewController?.window)
    }
    /// Close the welcomeViewController window
    @MainActor func closeWelcomeView() {
        welcomeViewController?.window?.close()
    }

    /// The controller for the ``AboutView`` window
    private var aboutViewController: NSWindowController?
    /// Show the ``AboutView`` window in Appkit
    @MainActor func showAboutView() {
        if aboutViewController == nil {
            let window = createWindow(title: "About Chord Provider")
            window.styleMask.remove(.titled)
            window.isMovableByWindowBackground = true
            window.contentView = NSHostingView(rootView: AboutView(appDelegate: self))
            window.backgroundColor = NSColor.clear
            window.center()
            aboutViewController = NSWindowController(window: window)
        }
        aboutViewController?.showWindow(aboutViewController?.window)
    }

    /// Close the welcomeViewController window
    @MainActor func closeAboutView() {
        aboutViewController?.window?.close()
    }

    /// The controller for the `ExportFolderView` window
    private var exportFolderController: NSWindowController?
    /// Show the `ExportFolderView` window in Appkit
    @MainActor func showExportFolderView() {
        if exportFolderController == nil {
            let window = createWindow(title: "Chord Provider")
            window.contentView = NSHostingView(rootView: ExportFolderView())
            window.center()
            exportFolderController = NSWindowController(window: window)
        }
        welcomeViewController?.window?.close()
        exportFolderController?.showWindow(exportFolderController?.window)
    }

    /// The controller for the ``ChordsDatabaseView`` window
    private var chordsDatabaseController: NSWindowController?
    /// Show the ``ChordsDatabaseView`` window in Appkit
    @MainActor func showChordsDatabaseView() {
        if chordsDatabaseController == nil {
            let window = createWindow(title: "Chords Database")
            window.styleMask.update(with: .resizable)
            window.contentView = NSHostingView(rootView: ChordsDatabaseView())
            window.center()
            chordsDatabaseController = NSWindowController(window: window)
        }
        welcomeViewController?.window?.close()
        chordsDatabaseController?.showWindow(chordsDatabaseController?.window)
    }

    @MainActor private func createWindow(title: String) -> NSWindow {
        let window = MyNSWindow()
        window.title = title
        window.styleMask = styleMask
        window.titlebarAppearsTransparent = true
        window.toolbarStyle = .unifiedCompact
        window.backgroundColor = NSColor(named: "TelecasterColor")
        /// Just a fancy animation; it is not a document window
        window.animationBehavior = .documentWindow
        return window
    }
}
extension AppDelegateModel {

    class MyNSWindow: NSWindow {
        override var canBecomeMain: Bool { true }
        override var canBecomeKey: Bool { true }
        override var acceptsFirstResponder: Bool { true }
    }
}
