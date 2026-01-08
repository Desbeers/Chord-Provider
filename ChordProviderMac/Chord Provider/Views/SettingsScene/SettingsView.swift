//
//  SettingsView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the settings
struct SettingsView: View {
    /// The observable ``FileBrowserModel`` class
    @Environment(FileBrowserModel.self) var fileBrowser
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// Sort tokens
    @State var sortTokens: String = ""
    /// JSON export string
    @State var jsonExportString: String = ""
    /// JSON export dialog
    @State var showJsonExportDialog: Bool = false
    /// JSON import dialog
    @State var showJsonImportDialog: Bool = false
    /// Show an `Alert` if we have an error
    @State var errorAlert: AlertMessage?
    /// The body of the `View`
    var body: some View {
        TabView {
            Tab("Editor", systemImage: "pencil") {
                editor
            }
            Tab("Diagrams", systemImage: "guitars") {
                diagram
            }
            Tab("Songs", systemImage: "folder") {
                folder
            }
            Tab("Style", systemImage: "paintpalette") {
                style
            }
            Tab("Options", systemImage: "music.quarternote.3") {
                options
            }
            Tab("PDF", systemImage: "text.document") {
                pdf
            }
        }
        .errorAlert(message: $errorAlert)
    }
}


extension SettingsView {

    /// Wrap the settings section
    struct WrapSettingsSection: ViewModifier {
        /// The title of the section
        let title: String
        /// The body of the `View`
        func body(content: Content) -> some View {
            VStack(alignment: .center) {
                Text(title)
                    .font(.headline)
                VStack {
                    content
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primary.opacity(0.04).cornerRadius(8))
            }
            .padding([.top, .horizontal])
            .frame(maxWidth: .infinity)
        }
    }
}

extension View {

    /// Shortcut to the ``SettingsView/WrapSettingsSection`` modifier
    /// - Parameter title: The title
    /// - Returns: A modified `View`
    func wrapSettingsSection(title: String) -> some View {
        modifier(SettingsView.WrapSettingsSection(title: title))
    }
}
