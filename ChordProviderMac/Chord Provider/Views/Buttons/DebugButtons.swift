//
//  DebugButtons.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `View` with debug buttons
struct DebugButtons: View {
    /// The observable state of the scene
    @FocusedValue(\.sceneState) private var sceneState: SceneStateModel?
    /// The body of the `View`
    var body: some View {
        ExportJSONButton(song: sceneState?.song)
        Divider()
        Button(
            action: {
                /// Remove user defaults
                if let bundleID = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                }
                /// Delete the settings
                for setting in AppSettings.AppWindowID.allCases {
                    try? SettingsCache.delete(id: setting.rawValue)
                }
                /// Terminate the application
                /// - Note: This will also clean the temporarily files
                NSApp.terminate(nil)
            },
            label: {
                Text("Reset Application")
            }
        )
        Button(
            action: {
                /// Open the **Chord Provider** temporary folder
                NSWorkspace.shared.open(Song.temporaryDirectoryURL)
            },
            label: {
                Text("Open temporary folder")
            }
        )
    }
}
