//  MARK: - App: the scenes for the application

/// macOS and iOS have their own scenes because they are too different

import SwiftUI

@main
struct ChordProviderApp: App {
    /// Get the list of chord diagrams so we don't have to parse it all the time.
    let diagrams = Diagram.all

    var body: some Scene {
        #if os(macOS)
        macOSApp(diagrams: diagrams)
        #endif
        #if os(iOS)
        iOSApp(diagrams: diagrams)
        #endif
    }
}

//  MARK: - Scene: macOS

#if os(macOS)
struct macOSApp: Scene {
    /// Below are used for the "Toggle Appearance" menu command.
    @AppStorage("appColor") var appColor: AppAppearance.displayMode = .system
    @AppStorage("appAppearance") var appAppearance: AppAppearance.displayMode = .system

    let diagrams: [Diagram]
    
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            NavigationView {
                FileBrowser(document: file.$document, file: file)
                MainView(document: file.$document, diagrams: diagrams)
            }
        }
        .commands {
            /// Show or hide the sidebar
            SidebarCommands()
            CommandGroup(before: .sidebar)  {
                Button(action: {
                    if (appColor == .light) {
                        appAppearance = .dark
                    } else {
                        appAppearance = .light
                    }
                }) {
                    Text("Toggle Appearance")
                }
                .keyboardShortcut("t")
            }
        }
    }
}
#endif

//  MARK: - Scene: iOS

#if os(iOS)
struct iOSApp: Scene {

    let diagrams: [Diagram]
    
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            MainView(document: file.$document, diagrams: diagrams)
        }
    }
}
#endif
