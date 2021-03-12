//  MARK: - App: the scenes for the application

/// macOS and iOS have their own scenes because they are too different

import SwiftUI

@main
struct ChordProviderApp: App {
    var body: some Scene {
        #if os(macOS)
        macOSApp()
        #endif
        #if os(iOS)
        iOSApp()
        #endif
    }
}

//  MARK: - Scene: macOS

#if os(macOS)
struct macOSApp: Scene {
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            NavigationView {
                FileBrowser(document: file.$document, file: file)
                MainView(document: file.$document)
            }
        }
        .commands {
            /// Show or hide the sidebar
            SidebarCommands()
        }
    }
}
#endif

//  MARK: - Scene: iOS

#if os(iOS)
struct iOSApp: Scene {
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            MainView(document: file.$document)
        }
    }
}
#endif
