import Foundation
import Adwaita

/// The main `View` for the application
struct Main: View {

    @State private var appState = AppState()

        /// A signal to open a file
        @State private var openFile = Signal()
        /// Show a toast
        @State private var showToast = Signal()
        /// The toast message
        @State private var toastMessage: String = ""

    var view: Body {
        VStack {
            HStack {
                // NESTED
                VStack {
                    Text("NESTED")
                        .title1()
                    Button("Toast me") {
                        appState.scene.toastMessage = Date.now.formatted()
                        appState.scene.showToast.signal()
                    }
                    .halign(.center)
                    .padding()
                    Button("Open file") {
                        appState.scene.openFile.signal()
                    }
                    .halign(.center)
                    .padding()
                    Text(helpText)
                }
                .padding()
                .hexpand()
                // The **Toast** message
                .toast(
                    appState.scene.toastMessage,
                    signal: $appState.scene.showToast
                )
                .fileImporter(open: $appState.scene.openFile) { url in
                    appState.scene.toastMessage = url.lastPathComponent
                    appState.scene.showToast.signal()
                }
                Separator()
                // NOT NESTED
                VStack {
                    Text("NOT NESTED")
                        .title1()
                    Button("Toast me") {
                        toastMessage = Date.now.formatted()
                        showToast.signal()
                    }
                    .halign(.center)
                    .padding()
                    Button("Open file") {
                        openFile.signal()
                    }
                    .halign(.center)
                    .padding()
                    Text("/// Normal, no problems")
                }
                .padding()
                .hexpand()
                // The **Toast** message
                .toast(
                    toastMessage,
                    signal: $showToast
                )
                .fileImporter(open: $openFile) { url in
                    toastMessage = url.lastPathComponent
                    showToast.signal()
                }
            }
        }
    }
}

/// Appstate
struct AppState {
    var scene = Scene()
}

extension AppState {

    /// Scenestate
    struct Scene {
        /// A signal to open a file
        var openFile = Signal()
        /// Show a toast
        var showToast = Signal()
        /// The toast message
        var toastMessage: String = ""
    }
}

let helpText: String = """
    /// Signals repeats previous signals
    ///
    /// - Press toast button
    /// - Press toast button again: it repeats itself twise
    ///
    /// - Press file button, select file
    /// - Press toast button, file dialog pops-up again
    ///
    /// The signals are nested in the appState/Scene struct
"""