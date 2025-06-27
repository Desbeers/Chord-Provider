//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `Scene` for **Chord Provider**
@main struct ChordProviderApp: App {
    /// The observable state of the application
    @State private var appState = AppStateModel(id: .mainView)
    /// The observable state of the file browser
    @State private var fileBrowser = FileBrowserModel()
    /// The ``AppDelegate`` class  for **Chord Provider**
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    /// Environment to open windows
    @Environment(\.openWindow) private var openWindow
    /// Environment to dismiss windows
    @Environment(\.dismissWindow) private var dismissWindow
    /// The body of the `Scene`
    var body: some Scene {

        // MARK: 'Song' document window

        /// The actual 'song' window
        DocumentGroup(newDocument: ChordProDocument()) { file in
            MainView(document: file.$document, fileURL: file.fileURL)
                .environment(appState)
                .environment(fileBrowser)
            /// Give the scene access to the document.
                .focusedSceneValue(\.document, file)
                .task {
                    /// Close the Welcome window if open
                    dismissWindow(id: AppDelegate.WindowID.welcomeView.rawValue)
                }
        }
        .defaultLaunchBehavior(.suppressed)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button {
                    openWindow(id: AppDelegate.WindowID.aboutView.rawValue)
                } label: {
                    Text("About Chord Provider")
                }
            }
            CommandGroup(after: .newItem) {
                Divider()
                Button {
                    openWindow(id: AppDelegate.WindowID.welcomeView.rawValue)
                } label: {
                    Label("Browser…", systemImage: "folder")
                }
                .keyboardShortcut("b")
            }
            CommandGroup(after: .newItem) {
                Divider()
                Button {
                    openWindow(id: AppDelegate.WindowID.exportFolderView.rawValue)
                    /// Close the Welcome window if open
                    dismissWindow(id: AppDelegate.WindowID.welcomeView.rawValue)
                } label: {
                    Label("Export Folder…", systemImage: "square.and.arrow.up")
                }
            }
            CommandGroup(after: .toolbar) {
                WindowVisibilityToggle(windowID: AppDelegate.WindowID.chordsDatabaseView.rawValue)
                Divider()
                WindowVisibilityToggle(windowID: AppDelegate.WindowID.debugView.rawValue)
                Divider()
            }
#if DEBUG
            CommandMenu("Debug") {
                DebugButtons()
            }
#endif
            CommandGroup(after: .importExport) {
                ExportSongButton()
                    .keyboardShortcut("e")
            }
            CommandGroup(after: .importExport) {
                PrintPDFButton(label: "Print…")
                    .keyboardShortcut("p")
            }
            CommandGroup(after: .textEditing) {
                FontSizeButtons()
                    .environment(appState)
            }
            CommandGroup(replacing: .help) {
                HelpButtons()
            }
        }
        .defaultSize(width: 1000, height: 800)
        .defaultPosition(.center)

        // MARK: Welcome window

        Window(AppDelegate.WindowID.welcomeView.rawValue, id: AppDelegate.WindowID.welcomeView.rawValue) {
            WelcomeView()
                .windowResizeBehavior(.disabled)
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .containerBackground(.thickMaterial, for: .window)
                .toolbar(removing: .title)
                .windowMinimizeBehavior(.disabled)
                .environment(appState)
                .environment(fileBrowser)
        }
        .defaultLaunchBehavior(.presented)
        .defaultWindowPlacement { content, context in
            centerWindow(content: content, context: context)
        }
        .restorationBehavior(.disabled)
        .commandsRemoved()


        // MARK: About window

        Window(AppDelegate.WindowID.aboutView.rawValue, id: AppDelegate.WindowID.aboutView.rawValue) {
            AboutView()
                .windowResizeBehavior(.disabled)
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .containerBackground(.thickMaterial, for: .window)
                .toolbar(removing: .title)
                .windowMinimizeBehavior(.disabled)
        }
        .defaultLaunchBehavior(.suppressed)
        .defaultWindowPlacement { content, context in
            centerWindow(content: content, context: context)
        }
        .restorationBehavior(.disabled)
        .commandsRemoved()

        // MARK: Chords Database window

        Window(AppDelegate.WindowID.chordsDatabaseView.rawValue, id: AppDelegate.WindowID.chordsDatabaseView.rawValue) {
            ChordsDatabaseView()
        }
        .defaultLaunchBehavior(.suppressed)
        .commandsRemoved()

        // MARK: Debug window

        Window(AppDelegate.WindowID.debugView.rawValue, id: AppDelegate.WindowID.debugView.rawValue) {
            DebugView()
                .toolbar(removing: .title)
                .environment(appState)
        }
        .defaultLaunchBehavior(.suppressed)
        .commandsRemoved()

        // MARK: Export Folder window

        Window(AppDelegate.WindowID.exportFolderView.rawValue, id: AppDelegate.WindowID.exportFolderView.rawValue) {
            ExportFolderView()
                .environment(fileBrowser)
        }
        .defaultLaunchBehavior(.suppressed)
        .windowResizability(.contentSize)
        .commandsRemoved()

        // MARK: Media Player window

        Window(AppDelegate.WindowID.mediaPlayerView.rawValue, id: AppDelegate.WindowID.mediaPlayerView.rawValue) {
            MediaPlayerView()
                .environment(appState)
        }
        .defaultLaunchBehavior(.suppressed)
        .windowResizability(.contentMinSize)
        .commandsRemoved()

        // MARK: Help

        UtilityWindow(AppDelegate.WindowID.helpView.rawValue, id: AppDelegate.WindowID.helpView.rawValue) {
            HelpView()
                .environment(appState)
        }
        .defaultLaunchBehavior(.suppressed)
        .windowResizability(.contentSize)
        .commandsRemoved()

        // MARK: Settings

        /// The settings window
        Settings {
            SettingsView()
                .environment(appState)
                .environment(fileBrowser)
                .frame(width: 400, height: 490)
        }
    }

    // MARK: HELPERS

    /// More or less center a window
    func centerWindow(content: WindowLayoutRoot, context: WindowPlacementContext) -> WindowPlacement {
        let displayBounds = context.defaultDisplay.bounds
        let contentSize = content.sizeThatFits(.unspecified)
        let position = CGPoint(
            x: displayBounds.midX - (contentSize.width / 2),
            y: displayBounds.midY - (contentSize.height / 1.5)
        )
        return WindowPlacement(position, size: contentSize)
    }
}
