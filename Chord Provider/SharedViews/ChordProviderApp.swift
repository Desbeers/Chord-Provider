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
    @StateObject var mySongs = MySongs()
    
    // @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.newDocument) private var newDocument
    
    var body: some Scene {
        WindowGroup("Song List") {
            FileBrowserView()
                .padding(.top, 1)
                .frame(width: 320)
                .navigationTitle("Chord Provider")
                .navigationSubtitle("\(mySongs.songList.count) songs")
                .task {
                    mySongs.getFiles()
                }
                .environmentObject(mySongs)
        }
        /// Make it sizable by the View frame
        .windowResizability(.contentSize)
        .defaultPosition(.topLeading)
        
        /// Add Chord Provider to the Menu Bar
        MenuBarExtra("Chord Provider", systemImage: "guitars") {
            MenuBarExtraView()
                .environmentObject(mySongs)
        }
        .menuBarExtraStyle(.window)
        
        DocumentGroup(newDocument: ChordProDocument()) { file in
            ViewContent(document: file.$document, file: file.fileURL)
                .environmentObject(mySongs)
        }
        .defaultPosition(.center)
        .defaultSize(width: 800, height: 800)
    }
}

// class AppDelegate: NSObject, NSApplicationDelegate {
//
//    func applicationDidFinishLaunching(_ notification: Notification) {
//        if let window = NSApplication.shared.windows.first {
//            window.level = .popUpMenu
//            dump(window.tabbingMode)
//            window.titleVisibility = .visible
//            window.titlebarAppearsTransparent = true
//            window.isOpaque = true
//            window.tabbingMode = .preferred
//            window.backgroundColor = NSColor.clear
//        }
//    }
// }

#endif

// MARK: - Scene: iOS

#if os(iOS)
struct SceneIOS: Scene {
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            ViewContent(document: file.$document, file: file.fileURL ?? nil)
                .navigationBarHidden(true)
        }
    }
}

func goBack() {

    // https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0

    if let keyWindow = UIApplication.shared.mainKeyWindow {
        keyWindow.rootViewController?.dismiss(animated: true)    }
    
}

extension UIApplication {
    var mainKeyWindow: UIWindow? {
        return connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}

#endif
