//
//  WelcomeView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` for the Welcome Window
struct WelcomeView: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// The observable state of the file browser
    @Environment(FileBrowserModel.self) var fileBrowser
    /// The currently selected tab
    @State private var selectedTab: NewTabs = .recent

    /// Environment to open documents
    @Environment(\.openDocument) private var openDocument

    @Environment(\.newDocument) private var newDocument

    @Environment(\.openWindow) var openWindow

    @Environment(\.dismiss) var dismiss

    /// The body of the `View`
    var body: some View {
        HStack(spacing: 0) {
            createDocument
                .frame(maxHeight: .infinity)
                .padding([.leading, .bottom])
            VStack {
                VStack {
                    switch selectedTab {
                    case .recent:
                        recentFiles
                    case .yourSongs:
                        browserFiles
                    case .templates:
                        templates
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(nsColor: .textBackgroundColor))
            .labelStyle(.SongFile)
        }
        .toolbar {
            Spacer()
            Picker("Tabs", selection: $selectedTab) {
                ForEach(NewTabs.allCases) { tab in
                    Text(tab.rawValue)
                        .tag(tab)
                }
            }
            .pickerStyle(.segmented)
        }
        .buttonStyle(.plain)
        .frame(width: 640)
        .animation(.default, value: selectedTab)
        .gesture(WindowDragGesture())
        .task {
            appState.recentFiles = NSDocumentController.shared.recentDocumentURLs
        }
    }
}

extension WelcomeView {

    /// The available tabs for the ``WelcomeView``
    enum NewTabs: String, CaseIterable, Identifiable {
        /// The ID of the tab
        var id: String {
            self.rawValue
        }
        /// Recent opened songs
        case recent = "Recent"
        /// Songs in the file browser
        case yourSongs = "Your Songs"
        /// Templates
        case templates = "Templates"
    }
}

extension WelcomeView {
    func openSong(url: URL) async {
        do {
            try await openDocument(at: url)
        } catch {
            Logger.application.error("Error opening URL: \(error.localizedDescription, privacy: .public)")
        }
        dismiss()
    }
    func newSong(text: String, template: URL? = nil) {
        newDocument(ChordProDocument(text: text, template: template))
        dismiss()
    }
}
