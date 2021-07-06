// MARK: - App: the scenes for the application

/// macOS and iOS have their own scenes because they are too different

import SwiftUI

@main
struct ChordProviderApp: App {
    var body: some Scene {
        #if os(macOS)
        SceneMAC()
        #endif
        #if os(iOS)
        SceneIOS()
        #endif
    }
}

// MARK: - Scene: macOS

#if os(macOS)
struct SceneMAC: Scene {
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            NavigationView {
                FileBrowser(document: file.$document, file: file.fileURL ?? nil)
                MainView(document: file.$document, file: file.fileURL ?? nil)
            }
        }
        .commands {
            /// Show or hide the sidebar
            SidebarCommands()
        }
    }
}
#endif

// MARK: - Scene: iOS

#if os(iOS)
struct SceneIOS: Scene {
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            MainView(document: file.$document, file: file.fileURL ?? nil)
        }
    }
}
#endif
