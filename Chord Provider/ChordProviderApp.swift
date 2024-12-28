//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `Scene` for **Chord Provider**
@main struct ChordProviderApp: App {
    /// The observable ``FileBrowser`` class
    @State private var fileBrowser = FileBrowserModel.shared
    /// The observable state of the application
    @State private var appState = AppStateModel.shared
    /// The ``AppDelegate`` class  for **Chord Provider**
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegateModel
    /// Environment to open windows
    @Environment(\.openWindow) private var openWindow
    /// Environment to dismiss windows
    @Environment(\.dismissWindow) private var dismissWindow
    /// The body of the `Scene`
    var body: some Scene {

        // MARK: 'Song' document window

        /// The actual 'song' window
        DocumentGroup(newDocument: ChordProDocument(text: AppStateModel.shared.standardDocumentContent)) { file in
            MainView(document: file.$document, file: file.fileURL)
                .environment(fileBrowser)
                .environment(appState)
            /// Give the scene access to the document.
                .focusedSceneValue(\.document, file)
                .task {
                    /// Close the Welcome window if open
                    dismissWindow(id: AppDelegateModel.WindowID.welcomeView.rawValue)
                }
        }
        .defaultLaunchBehavior(.suppressed)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button {
                    openWindow(id: AppDelegateModel.WindowID.aboutView.rawValue)
                } label: {
                    Text("About Chord Provider")
                }
            }
            CommandGroup(after: .newItem) {
                Divider()
                Button {
                    openWindow(id: AppDelegateModel.WindowID.welcomeView.rawValue)
                } label: {
                    Text("Browser…")
                }
                .keyboardShortcut("b")
            }
            CommandGroup(after: .newItem) {
                Divider()
                Button {
                    openWindow(id: AppDelegateModel.WindowID.exportFolderView.rawValue)
                    /// Close the Welcome window if open
                    dismissWindow(id: AppDelegateModel.WindowID.welcomeView.rawValue)
                } label: {
                    Text("Export Folder…")
                }
            }
            CommandGroup(after: .toolbar) {
                WindowVisibilityToggle(windowID: AppDelegateModel.WindowID.chordsDatabaseView.rawValue)
                Divider()
                WindowVisibilityToggle(windowID: AppDelegateModel.WindowID.debugView.rawValue)
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

        Window(AppDelegateModel.WindowID.welcomeView.rawValue, id: AppDelegateModel.WindowID.welcomeView.rawValue) {
            WelcomeView(windowID: AppDelegateModel.WindowID.welcomeView)
                .windowResizeBehavior(.disabled)
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .containerBackground(.ultraThickMaterial, for: .window)
                .toolbar(removing: .title)
                .windowMinimizeBehavior(.disabled)
                .environment(appState)
        }
        .defaultLaunchBehavior(.presented)
        .defaultWindowPlacement { content, context in
            centerWindow(content: content, context: context)
        }
        .restorationBehavior(.disabled)
        .commandsRemoved()


        // MARK: About window

        Window(AppDelegateModel.WindowID.aboutView.rawValue, id: AppDelegateModel.WindowID.aboutView.rawValue) {
            AboutView()
                .windowResizeBehavior(.disabled)
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .containerBackground(.ultraThickMaterial, for: .window)
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

        Window(AppDelegateModel.WindowID.chordsDatabaseView.rawValue, id: AppDelegateModel.WindowID.chordsDatabaseView.rawValue) {
            ChordsDatabaseView()
        }
        .defaultLaunchBehavior(.suppressed)
        .commandsRemoved()

        // MARK: Debug window

        Window(AppDelegateModel.WindowID.debugView.rawValue, id: AppDelegateModel.WindowID.debugView.rawValue) {
            DebugView()
                .toolbar(removing: .title)
                .environment(appState)
        }
        .defaultLaunchBehavior(.suppressed)
        .commandsRemoved()

        // MARK: Export Folder window

        Window(AppDelegateModel.WindowID.exportFolderView.rawValue, id: AppDelegateModel.WindowID.exportFolderView.rawValue) {
            ExportFolderView()
        }
        .defaultLaunchBehavior(.suppressed)
        .windowResizability(.contentMinSize)
        .commandsRemoved()

        // MARK: Media Player window

        Window(AppDelegateModel.WindowID.mediaPlayerView.rawValue, id: AppDelegateModel.WindowID.mediaPlayerView.rawValue) {
            MediaPlayerView(appDelegate: appDelegate)
        }
        .defaultLaunchBehavior(.suppressed)
        .windowResizability(.contentMinSize)
        .commandsRemoved()

        // MARK: Settings

        /// The settings window
        Settings {
            SettingsView()
                .environment(appState)
                .environment(fileBrowser)
                .frame(width: 340, height: 490)
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
