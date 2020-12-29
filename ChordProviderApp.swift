import SwiftUI

@main
struct ChordProviderApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #endif
    init() {
        print("starting!!")
    }
    
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

#if os(macOS)
struct macOSApp: Scene {

    let diagrams: [Diagram]
    
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            NavigationView {
                FileBrowser(document: file.$document, file: file)
                MainView(document: file.$document, diagrams: diagrams)
            }
        }
    }
}
#endif

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
