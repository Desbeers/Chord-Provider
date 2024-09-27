//
//  DebugButtons.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with debug buttons
struct DebugButtons: View {
    /// The scene state in the environment
    @FocusedValue(\.sceneState) private var sceneState: SceneStateModel?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                /// Remove user defaults
                if let bundleID = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                }
                /// Delete the settings
                try? Cache.delete(key: "ChordProviderSettings-Main")
                try? Cache.delete(key: "ChordProviderSettings-FolderExport")
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


////
////  ResetApplicationButtonView.swift
////  Chord Provider
////
////  © 2024 Nick Berendsen
////
//
//import SwiftUI
//
///// SwiftUI `View` with a `Button` to reset the application
//public struct ResetApplicationButtonView: View {
//    /// Init the `View`
//    public init() {}
//    /// The body of the `View`
//    public var body: some View {
//        Button(
//            action: {
//                /// Remove user defaults
//                if let bundleID = Bundle.main.bundleIdentifier {
//                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
//                }
//                /// Delete the cache
//                let manager = FileManager.default
//                if let cacheFolderURL = manager.urls(
//                    for: .cachesDirectory,
//                    in: .userDomainMask
//                ).first {
//                    try? manager.removeItem(at: cacheFolderURL)
//                    try? manager.createDirectory(
//                        at: cacheFolderURL,
//                        withIntermediateDirectories: false,
//                        attributes: nil
//                    )
//                }
//                /// Terminate the application
//                NSApp.terminate(nil)
//            },
//            label: {
//                Text("Reset Application")
//            }
//        )
//    }
//}
