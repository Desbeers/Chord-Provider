import Foundation
import Adwaita

/// The content `View` for the application
struct Content: View {

    var app: AdwaitaApp
    var window: AdwaitaWindow

    @State("appstate") private var appState = AppState()

    @State private var showPreferencesDialog: Bool = false

    var view: Body {
        VStack {
            Text("Font Size Spinner")
                .title1()
            /// This will also reset the state to its initional value on start
            /// FontSizeSpinner(appState: $appState)
            Text(helpSpinner)
                .vexpand()
            Separator()
                .padding()
            Text("Font Value: \(appState.theme.editorFontSize)")
            .style("font-size")
            .css {
                """
                .font-size {
                    font-family: Monospace; font-size: \(appState.theme.editorFontSize)pt;
                }
                """
            }
        }
        .padding()
        .topToolbar {
            ToolbarView(app: app, window: window, appState: $appState, showPreferencesDialog: $showPreferencesDialog)
        }
        .preferencesDialog(visible: $showPreferencesDialog)
        .preferencesPage("General", icon: .default(icon: .folderMusic)) { page in
            page
                .group("Font Size") {
                    // Issues:
                    FontSizeSpinner(appState: $appState)
                    // Issues:
                    // FontSizeSpinner(appState: $appState, editorFontSize: $appState.theme.editorFontSize)
                    // Directly passing the Int binding; still issues
                    // FontSizeSpinner(editorFontSize: $appState.theme.editorFontSize)
                    /// Passing the theme; same issues
                    /// FontSizeSpinner(theme: $appState.theme)
                    Text("Font Value: \(appState.theme.editorFontSize)")
            }
        }
    }
}

/// Appstate
struct AppState: Codable, Equatable {
    var theme = Theme()
}

/// Settings for the theme (nested)
struct Theme: Codable, Equatable {
    /// The font size of the editor
    var editorFontSize: Int = 12
}

let helpSpinner: String = """
    /// All fine if I use an Int directly
    /// @State("editorFontSize") private var editorFontSize: Int = 12
    /// 
    /// All fine if I use the Theme struct directly
    /// @State("theme") private var theme = Theme()
    /// 
    /// Issues with a nested AppState struct containing Theme():
    /// @State("appstate") private var appState = AppState()
    /// 
    /// - If I go to Preferences, the value is reset to its initial state
    /// - If I change the value, close the Preferences and open it again; the application will crash.
    /// 
    /// Directly passing the Int as Binding: same issues.
    /// 
    /// I don't have any other issues with widgets and nested Structs
    /// See my ChordProvider application
"""