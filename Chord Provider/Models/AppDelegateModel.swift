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

    /// The controller for the `WelcomeView` window
    private var welcomeViewController: NSWindowController?
    /// Show the `NewDocumentView` window in Appkit
    @MainActor func showNewDocumentView() {
        if welcomeViewController == nil {
            let window = NSWindow()
            window.title = "Chord Provider"
            window.styleMask = [.closable, .titled, .fullSizeContentView]
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
            window.contentView = NSHostingView(rootView: WelcomeView(appDelegate: self))
            window.toolbarStyle = .unifiedCompact
            window.center()
            /// Just a fancy animation; it is not a document window
            window.animationBehavior = .documentWindow
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

    /// The controller for the `ExportFolderView` window
    private var exportFolderController: NSWindowController?
    /// Show the `ExportFolderView` window in Appkit
    @MainActor func showExportFolderView() {
        if exportFolderController == nil {
            let window = NSWindow()
            window.title = "Chord Provider"
            window.styleMask = [.closable, .miniaturizable, .titled, .fullSizeContentView]
            window.titlebarAppearsTransparent = true
            //window.isMovableByWindowBackground = true
            window.contentView = NSHostingView(rootView: ExportFolderView())
            window.toolbarStyle = .unifiedCompact
            window.backgroundColor = NSColor(named: "TelecasterColor")
            window.center()
            /// Just a fancy animation; it is not a document window
            window.animationBehavior = .documentWindow
            exportFolderController = NSWindowController(window: window)
        }
        welcomeViewController?.window?.close()
        exportFolderController?.showWindow(exportFolderController?.window)
    }
}
