//
//  WelcomeView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

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
    /// Environment to create new documents
    @Environment(\.newDocument) private var newDocument
    /// Environment to open windows
    @Environment(\.openWindow) var openWindow
    /// Environment to dismiss itself
    @Environment(\.dismiss) var dismiss
    /// A random song from the library
    @State var randomSong: Song?
    /// The body of the `View`
    var body: some View {
        @Bindable var fileBrowser = fileBrowser
        HStack(spacing: 0) {
            createDocument
                .frame(maxHeight: .infinity)
                .padding([.leading, .bottom])
                .padding()
            Divider()
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
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .labelStyle(.songFile)
        }
        .background(Color(nsColor: .textBackgroundColor))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Tabs", selection: $selectedTab) {
                    ForEach(NewTabs.allCases) { tab in
                        Text(tab.rawValue)
                            .tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .backport.glassEffect()
            }
        }
        .buttonStyle(.plain)
        .frame(width: 640)
        .animation(.default, value: selectedTab)
        .gesture(WindowDragGesture())
        .task {
            appState.recentFiles = NSDocumentController.shared.recentDocumentURLs
        }
        .task(id: fileBrowser.songs) {
            randomSong = fileBrowser.songs.randomElement()
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

    /// Open a song file
    /// - Parameter url: The URL of the file
    func openSong(url: URL) async {
        do {
            try await openDocument(at: url)
        } catch {
            LogUtils.shared.log(
                .init(
                    type: .error,
                    category: .application,
                    message: "Error opening URL: \(error.localizedDescription)"
                )
            )
        }
        dismiss()
    }

    /// Open a new song
    /// - Parameters:
    ///   - text: The content of the song
    ///   - template: The optional URL of the template
    func newSong(text: String, template: URL? = nil) {
        newDocument(ChordProDocument(text: text, template: template))
        dismiss()
    }
}
