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
@Observable @MainActor final class AppDelegateModel: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    let popover = NSPopover()
    var eventMonitor: EventMonitor?

    /// Close all windows except the menuBarExtra
    /// - Note: Part of the `DocumentGroup` dirty hack; don't show the NSOpenPanel
    func applicationDidFinishLaunching(_ notification: Notification) {
        for window in NSApp.windows where window.styleMask.rawValue != 0 {
            window.close()
        }
        setupMenuBarExtra()
        //showWelcomeWindow()
        showChordsDatabaseView()
    }

    @objc func togglePopover(_ sender: NSStatusItem) {
        popover.isShown ? closePopover(sender: sender) : showPopover(sender: sender)
    }

    func showPopover(sender: Any?) {
        if let button = self.statusItem?.button {
            /// Close the Welcome window
            closeWelcomeWindow()
            /// Update the recent files list
            AppStateModel.shared.recentFiles = NSDocumentController.shared.recentDocumentURLs
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            self.eventMonitor?.start()
        }
    }

    func closePopover(sender: Any?) {
        self.popover.performClose(sender)
        self.eventMonitor?.stop()
    }

    /// Show the `NewDocumentView` instead of the NSOpenPanel when there are no documents open
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        switch flag {
        case true:
            return true
        case false:
            showWelcomeWindow()
            return false
        }
    }

    /// Don't terminate when the last **Chord Provider** window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    func setupMenuBarExtra() {

        switch AppStateModel.shared.settings.application.showMenuBarExtra {

        case true:
            if statusItem == nil {
                let statusBar = NSStatusBar.system
                statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
                if let button = self.statusItem?.button, let image = NSImage(named: "MenuBarExtra") {
                    image.size.height = 18
                    image.size.width = 18
                    image.isTemplate = true
                    button.image = image
                    button.action = #selector(self.togglePopover(_:))
                }
                let welcomeView = WelcomeView(appDelegate: self, windowID: .menuBarExtra)
                self.popover.contentViewController = NSHostingController(rootView: welcomeView)
                self.popover.contentViewController?.view.frame = NSRect(x: 0, y: 0, width: 640, height: 460)

                self.eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
                    if let strongSelf = self, strongSelf.popover.isShown {
                        strongSelf.closePopover(sender: event)
                    }
                }
            }
        case false:
            statusItem = nil
        }
    }

    /// Default style mask
    let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable, .titled, .fullSizeContentView]

    // MARK: Welcome window

    /// The controller for the `Welcome` window
    private var welcomeWindowController: NSWindowController?
    /// Show the ``WelcomeView`` in an AppKit window
    func showWelcomeWindow() {
        if welcomeWindowController == nil {
            let welcomeView = WelcomeView(appDelegate: self, windowID: .welcomeView)
                .closeWindowModifier {
                    self.closeWelcomeWindow()
                }
            let window = createWindow(id: .welcomeView)
            window.styleMask.remove(.titled)
            window.backgroundColor = NSColor.clear
            window.isMovableByWindowBackground = true
            window.contentView = NSHostingView(rootView: welcomeView)
            window.center()
            welcomeWindowController = NSWindowController(window: window)
        }
        /// Update the recent files list
        AppStateModel.shared.recentFiles = NSDocumentController.shared.recentDocumentURLs
        welcomeWindowController?.showWindow(nil)
    }
    /// Close the ``WelcomeView`` window
    func closeWelcomeWindow() {
        closePopover(sender: statusItem)
        welcomeWindowController?.window?.close()
        NSApp.activate(ignoringOtherApps: true)
    }

    // MARK: About window

    /// The controller for the `About` window
    private var aboutViewController: NSWindowController?
    /// Show the ``AboutView`` in an AppKit window
    func showAboutView() {
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
    /// Close the ``AboutView`` window
    func closeAboutView() {
        aboutViewController?.window?.close()
    }

    // MARK: Media Player window

    /// The controller for the `Media Player` window
    var mediaPlayerViewController: NSWindowController?
    /// Show the ``MediaPlayerView`` in an AppKit window
    func showMediaPlayerView() {
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

    /// Close the ``MediaPlayerView`` window
    func closeMediaPlayerView() {
        mediaPlayerViewController?.window?.close()
    }

    // MARK: Export Folder window

    /// The controller for the `Export Folder` window
    private var exportFolderViewController: NSWindowController?
    /// Show the ``ExportFolderView`` in an AppKit window
    func showExportFolderView() {
        if exportFolderViewController == nil {
            let window = createWindow(id: .exportFolderView)
            window.contentView = NSHostingView(rootView: ExportFolderView())
            window.center()
            exportFolderViewController = NSWindowController(window: window)
        }
        closePopover(sender: self)
        welcomeWindowController?.window?.close()
        exportFolderViewController?.showWindow(nil)
    }

    // MARK: Chord Database window

    /// The controller for the `Chords Database` window
    private var chordsDatabaseViewController: NSWindowController?
    /// Show the ``ChordsDatabaseView`` in an AppKit window
    func showChordsDatabaseView() {
        if chordsDatabaseViewController == nil {
            let window = createWindow(id: .chordsDatabaseView)
            window.styleMask.update(with: .resizable)
            window.titlebarAppearsTransparent = false
            window.contentView = NSHostingView(rootView: ChordsDatabaseView())
            window.center()
            chordsDatabaseViewController = NSWindowController(window: window)
        }
        closePopover(sender: self)
        welcomeWindowController?.window?.close()
        chordsDatabaseViewController?.showWindow(nil)
    }

    // MARK: Create a default NSWindow

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
        /// The ``WelcomeView`` in the menu bar
        case menuBarExtra = "MenuBarExtra"
        /// The ``AboutView``
        case aboutView = "About Chord Provider"
        /// The ``MediaPlayerView
        case mediaPlayerView = "Chord Provider Media"
        /// The ``ExportFolderView``
        case exportFolderView = "Export Songs"
        /// The ``ChordsDatabaseView``
        case chordsDatabaseView = "Chords Database"
    }
}

extension AppDelegateModel {

    /// Make a NSWindow that can be kay and main
    /// - Note:Needed for Windows that that don't have the `.titled` style mask
    class MyNSWindow: NSWindow {
        /// The window can become main
        override var canBecomeMain: Bool { true }
        /// The window can become key
        override var canBecomeKey: Bool { true }
        /// The window accepts first responder
        override var acceptsFirstResponder: Bool { true }
    }
}


extension AppDelegateModel {

    class EventMonitor {
        private var monitor: Any?
        private let mask: NSEvent.EventTypeMask
        private let handler: (NSEvent?) -> Void

        init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
            self.mask = mask
            self.handler = handler
        }

        deinit {
            stop()
        }

        func start() {
            self.monitor = NSEvent.addGlobalMonitorForEvents(matching: self.mask, handler: self.handler)
        }

        func stop() {
            if let eventMonitor = self.monitor {
                NSEvent.removeMonitor(eventMonitor)
                self.monitor = nil
            }
        }
    }
}
