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
    @State private var appState = AppStateModel.shared
    /// The observable ``FileBrowser`` class
    @State private var fileBrowser = FileBrowserModel.shared
    /// The AppDelegate to bring additional Windows into the SwiftUI world
    let appDelegate: AppDelegateModel
    /// The ID of the Window
    let windowID: AppDelegateModel.WindowID
    /// The currently selected tab
    @State private var selectedTab: NewTabs = .recent
    /// The body of the `View`
    var body: some View {
        HStack(spacing: 0) {
            CreateDocument(appDelegate: appDelegate)
                .frame(maxHeight: .infinity)
                .padding([.leading, .bottom])
                .background(.ultraThickMaterial)
            VStack {
                Picker("Tabs", selection: $selectedTab) {
                    ForEach(NewTabs.allCases) { tab in
                        Text(tab.rawValue)
                            .tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding(.top)
                VStack {
                    switch selectedTab {
                    case .recent:
                        RecentFiles(appDelegate: appDelegate)
                    case .yourSongs:
                        FileBrowser()
                    }
                }
                .frame(maxHeight: .infinity)
                    if windowID == .welcomeView {
                        Toggle("Show this window when creating a new document", isOn: $appState.settings.application.showWelcomeWindow)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.bottom)
                            .controlSize(.small)
                    }
            }
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(nsColor: .textBackgroundColor))
            .labelStyle(.SongFile)
        }
        .buttonStyle(.plain)
        .frame(width: 640)
        .animation(.default, value: selectedTab)
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
    }
}
