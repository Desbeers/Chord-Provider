//
//  DebugButtons.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with debug buttons
struct DebugButtons: View {
    /// The observable state of the scene
    @FocusedValue(\.sceneState) private var sceneState: SceneStateModel?
    /// The body of the `View`
    var body: some View {
        ExportJSONButton()
            .disabled(sceneState == nil)
        Divider()
        Button(
            action: {
                /// Remove user defaults
                if let bundleID = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                }
                /// Delete the settings
                try? SettingsCache.delete(key: "ChordProviderSettings-Main")
                try? SettingsCache.delete(key: "ChordProviderSettings-FolderExport")
                /// Terminate the application
                NSApp.terminate(nil)
            },
            label: {
                Text("Reset Application")
            }
        )
        Button(
            action: {
                /// Open the **ChordPro** temporary folder
                if let sceneState {
                    NSWorkspace.shared.open(sceneState.temporaryDirectoryURL)
                }
            },
            label: {
                Text("Open temporary folder")
            }
        )
        .disabled(sceneState == nil)
    }
}
