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
@Observable @MainActor final class AppDelegateModel: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var statusItem: NSStatusItem?
    let popover = NSPopover()
    var eventMonitor: EventMonitor?

    var saveChordDatabaseDialog: Bool = false

    var song: Song?

    var lastUpdate: Date = .now

    /// Close all windows except the menuBarExtra
    /// - Note: Part of the `DocumentGroup` dirty hack; don't show the NSOpenPanel
    func applicationDidFinishLaunching(_ notification: Notification) {
        for window in NSApp.windows where window.styleMask.rawValue != 0 {
            window.close()
        }
        setupMenuBarExtra()
        showWelcomeWindow()
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
        openWindow(controller: welcomeWindowController)
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
    func showAboutWindow() {
        if aboutViewController == nil {
            let window = createWindow(id: .aboutView)
            window.styleMask.remove(.titled)
            window.backgroundColor = NSColor.clear
            window.isMovableByWindowBackground = true
            window.contentView = NSHostingView(rootView: AboutView(appDelegate: self))
            window.center()
            aboutViewController = NSWindowController(window: window)
        }
        openWindow(controller: aboutViewController)
    }
    /// Close the ``AboutView`` window
    func closeAboutWindow() {
        aboutViewController?.window?.close()
    }

    // MARK: Media Player window

    /// The controller for the `Media Player` window
    var mediaPlayerViewController: NSWindowController?
    /// Show the ``MediaPlayerView`` in an AppKit window
    func showMediaPlayerWindow() {
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
        openWindow(controller: mediaPlayerViewController)
    }

    /// Close the ``MediaPlayerView`` window
    func closeMediaPlayerWindow() {
        mediaPlayerViewController?.window?.close()
    }

    // MARK: Export Folder window

    /// The controller for the `Export Folder` window
    private var exportFolderViewController: NSWindowController?
    /// Show the ``ExportFolderView`` in an AppKit window
    func showExportFolderWindow() {
        if exportFolderViewController == nil {
            let window = createWindow(id: .exportFolderView)
            window.contentView = NSHostingView(rootView: ExportFolderView())
            window.center()
            exportFolderViewController = NSWindowController(window: window)
        }
        closePopover(sender: self)
        welcomeWindowController?.window?.close()
        openWindow(controller: exportFolderViewController)
    }

    // MARK: Chord Database window

    /// The controller for the `Chords Database` window
    var chordsDatabaseViewController: NSWindowController?
    /// Show the ``ChordsDatabaseView`` in an AppKit window
    func showChordsDatabaseWindow() {
        if chordsDatabaseViewController == nil {
            let window = createWindow(id: .chordsDatabaseView)
            window.styleMask.update(with: .resizable)
            window.titlebarAppearsTransparent = false
            window.contentView = NSHostingView(rootView: ChordsDatabaseView(appDelegate: self))
            window.center()
            chordsDatabaseViewController = NSWindowController(window: window)
        }
        closePopover(sender: self)
        welcomeWindowController?.window?.close()
        openWindow(controller: chordsDatabaseViewController)
    }

    // MARK: Debug window

    /// The controller for the `Debug` window
    private var debugViewController: NSWindowController?
    /// Show the ``DebugView`` in an AppKit window
    func showDebugWindow() {
        if debugViewController == nil {
            let window = createWindow(id: .debugView)
            window.styleMask.update(with: .resizable)
            window.toolbarStyle = .preference
            window.contentView = NSHostingView(rootView: DebugView(appDelegate: self))
            window.center()
            debugViewController = NSWindowController(window: window)
        }
        closePopover(sender: self)
        welcomeWindowController?.window?.close()
        openWindow(controller: debugViewController)
    }

    // MARK: Open a Window

    /// Open a window and make it key and front
    /// - Parameter controller: The `NSWindowController` of the window
    @MainActor private func openWindow(controller: NSWindowController?) {
        controller?.showWindow(nil)
        controller?.window?.makeKey()
        controller?.window?.orderFrontRegardless()
    }

    // MARK: Create a default NSWindow

    @MainActor private func createWindow(id: WindowID) -> NSWindow {
        let window = MyNSWindow()
        window.title = id.rawValue
        window.styleMask = styleMask
        window.titlebarAppearsTransparent = true
        window.toolbarStyle = .unified
        window.identifier = NSUserInterfaceItemIdentifier(id.rawValue)
        window.backingType = .buffered
        window.delegate = self
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
        /// The ``DebugView``
        case debugView = "Debug"
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        guard let windowID = WindowID(rawValue: sender.identifier?.rawValue ?? "") else {
            return true
        }
        switch windowID {
        case .chordsDatabaseView:
            if let window = chordsDatabaseViewController?.window, window.isDocumentEdited {
                saveChordDatabaseDialog = true
                return false
            }
            return true
        default:
            return true
        }
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
