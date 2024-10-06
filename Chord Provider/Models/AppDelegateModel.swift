//
//  AppDelegateModel.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The observable application delegate for **Chord Provider**
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
        //showNewDocumentView()
        showChordsDatabaseView()
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

    // MARK: Welcome Window

    /// The controller for the `WelcomeView` window
    private var welcomeViewController: NSWindowController?
    /// Show the `WelcomeView` window in Appkit
    @MainActor func showNewDocumentView() {
        if welcomeViewController == nil {
            let window = createWindow(id: .welcomeView)
            window.styleMask.remove(.titled)
            window.backgroundColor = NSColor.clear
            window.isMovableByWindowBackground = true
            window.contentView = NSHostingView(rootView: WelcomeView(appDelegate: self).closeWindowModifier { self.closeWelcomeView() })
            window.center()
            welcomeViewController = NSWindowController(window: window)
        }
        /// Update the recent files list
        AppStateModel.shared.recentFiles = NSDocumentController.shared.recentDocumentURLs
        welcomeViewController?.showWindow(nil)
    }
    /// Close the welcomeViewController window
    @MainActor func closeWelcomeView() {
        welcomeViewController?.window?.close()
    }

    // MARK: About Window

    /// The controller for the ``AboutView`` window
    private var aboutViewController: NSWindowController?
    /// Show the ``AboutView`` window in Appkit
    @MainActor func showAboutView() {
        if aboutViewController == nil {
            let window = createWindow(id: .aboutView)
            window.styleMask.remove(.titled)
            window.backgroundColor = NSColor.clear
            window.isMovableByWindowBackground = true
            window.contentView = NSHostingView(rootView: AboutView(appDelegate: self))
            window.center()
            aboutViewController = NSWindowController(window: window)
        }
        aboutViewController?.showWindow(nil)
    }

    /// Close the welcomeViewController window
    @MainActor func closeAboutView() {
        aboutViewController?.window?.close()
    }

    // MARK: Media Player Window

    /// The controller for the ``MediaPlayerView`` window
    var mediaPlayerViewController: NSWindowController?
    /// Show the ``MediaPlayerView`` window in Appkit
    @MainActor func showMediaPlayerView() {
        if mediaPlayerViewController == nil {
            let window = createWindow(id: .mediaPlayerView)
            window.styleMask.update(with: .resizable)
            window.isMovableByWindowBackground = true
            window.contentView = NSHostingView(rootView: MediaPlayerView(appDelegate: self))
            window.titlebarAppearsTransparent = true
            window.backgroundColor = NSColor.black
            window.center()
            mediaPlayerViewController = NSWindowController(window: window)
        }
        mediaPlayerViewController?.showWindow(nil)
    }

    /// Close the welcomeViewController window
    @MainActor func closeMediaPlayerView() {
        mediaPlayerViewController?.window?.close()
    }

    // MARK: Export Folder Window

    /// The controller for the `ExportFolderView` window
    private var exportFolderViewController: NSWindowController?
    /// Show the `ExportFolderView` window in Appkit
    @MainActor func showExportFolderView() {
        if exportFolderViewController == nil {
            let window = createWindow(id: .exportFolderView)
            window.contentView = NSHostingView(rootView: ExportFolderView())
            window.center()
            exportFolderViewController = NSWindowController(window: window)
        }
        welcomeViewController?.window?.close()
        exportFolderViewController?.showWindow(nil)
    }

    // MARK: Chord Database Window

    /// The controller for the ``ChordsDatabaseView`` window
    private var chordsDatabaseViewController: NSWindowController?
    /// Show the ``ChordsDatabaseView`` window in Appkit
    @MainActor func showChordsDatabaseView() {
        if chordsDatabaseViewController == nil {
            let window = createWindow(id: .chordsDatabaseView)
            window.styleMask.update(with: .resizable)
            window.contentView = NSHostingView(rootView: ChordsDatabaseView())
            window.center()
            chordsDatabaseViewController = NSWindowController(window: window)
        }
        welcomeViewController?.window?.close()
        chordsDatabaseViewController?.showWindow(nil)
    }

    // MARK: Default Window

    @MainActor private func createWindow(id: WindowID) -> NSWindow {
        let window = MyNSWindow()
        window.title = id.rawValue
        window.styleMask = styleMask
        window.titlebarAppearsTransparent = true
        window.toolbarStyle = .unified
        window.identifier = NSUserInterfaceItemIdentifier(id.rawValue)
        /// Just a fancy animation; it is not a document window
        window.animationBehavior = .documentWindow
        return window
    }

    // MARK: App Window ID's

    /// The windows we can open
    enum WindowID: String {
        /// The ``WelcomeView``
        case welcomeView = "Chord Provider"
        /// The ``aboutView``
        case aboutView = "About Chord Provider"
        /// The ``mediaPlayerView
        case mediaPlayerView = "Chord Provider Media"
        /// The ``exportFolderView``
        case exportFolderView = "Export Songs"
        /// The ``chordsDatabaseView``
        case chordsDatabaseView = "Chords Database"
    }
}

extension AppDelegateModel {

    /// Make a NSWindow that can be key and main
    class MyNSWindow: NSWindow {
        override var canBecomeMain: Bool { true }
        override var canBecomeKey: Bool { true }
        override var acceptsFirstResponder: Bool { true }
    }
}
