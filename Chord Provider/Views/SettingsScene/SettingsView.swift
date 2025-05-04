//
//  SettingsView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` for the settings
struct SettingsView: View {
    /// The observable ``FileBrowserModel`` class
    @Environment(FileBrowserModel.self) var fileBrowser
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// Bool if **ChordPro CLI** is available
    @State var haveChordProCLI: Bool = false
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
        .fileExporter(
            isPresented: $showJsonExportDialog,
            document: JSONDocument(string: jsonExportString),
            contentTypes: [.json],
            defaultFilename: "Theme"
        ) { result in
            switch result {
            case .success(let url):
                Logger.fileAccess.info("Database exported to \(url, privacy: .public)")
            case .failure(let error):
                Logger.fileAccess.error("Export failed: \(error.localizedDescription, privacy: .public)")
            }
        }
        .fileImporter(
            isPresented: $showJsonImportDialog,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let files):
                do {
                    try files.forEach { url in
                        let text = try Data(contentsOf: url)
                        appState.settings.style = try JSONDecoder().decode(AppSettings.Style.self, from: text)
                        Logger.fileAccess.info("Theme imported from \(url, privacy: .public)")
                    }
                } catch {
                    Logger.fileAccess.error("Import failed: \(error.localizedDescription, privacy: .public)")
                    errorAlert = AppError.importThemeError.alert()
                }
            case .failure(let error):
                Logger.fileAccess.error("Import failed: \(error.localizedDescription, privacy: .public)")
                errorAlert = AppError.importThemeError.alert()
            }
        }
        .task {
            haveChordProCLI = await checkChordProCLI()
        }
    }
}

extension SettingsView {

    /// Check if the **ChordPro** cli is found in the $PATH
    /// - Returns: True or false
    func checkChordProCLI() async -> Bool {
        if (try? await Terminal.getChordProBinary()) != nil {
            return true
        }
        return false
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
