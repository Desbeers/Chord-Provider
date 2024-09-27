//
//  WelcomeView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

@MainActor struct WelcomeView: View {
    /// The state of the app
    @State private var appState = AppStateModel.shared
    /// The AppDelegate to bring additional Windows into the SwiftUI world
    let appDelegate: AppDelegateModel
    /// The currently selected tab
    @State private var selectedTab: NewTabs = .recent
    /// The body of the `View`
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 10) {
                // swiftlint:disable:next force_unwrapping
                Image(nsImage: NSImage(named: "AppIcon")!)
                    .resizable()
                    .frame(width: 280, height: 280)
                    .transition(.slide)
                VStack(alignment: .leading) {
                    Button(
                        action: {
                            appState.newDocumentContent = ChordProDocument.newText
                            NSDocumentController.shared.newDocument(nil)
                        },
                        label: {
                            Label("Start with an empty song", systemImage: "doc")
                        }
                    )
                    Button(
                        action: {
                            Task {
                                if let urls = await NSDocumentController.shared.beginOpenPanel() {
                                    for url in urls {
                                        do {
                                            try await NSDocumentController.shared.openDocument(withContentsOf: url, display: true)
                                        } catch {
                                            Logger.application.error("Error opening URL: \(error.localizedDescription, privacy: .public)")
                                        }
                                    }
                                }
                            }
                        },
                        label: {
                            Label("Open a **ChordPro** song", systemImage: "doc.badge.ellipsis")
                        }
                    )
                    Button(
                        action: {
                            appDelegate.showExportFolderView()
                        },
                        label: {
                            Label("Export a folder with songs", systemImage: "doc.on.doc")
                        }
                    )
                }
                .labelStyle(ButtonLabelStyle())
            }
            .frame(maxHeight: .infinity)
            .padding([.leading, .bottom])
            .background(Color.telecaster)
            VStack {
                switch selectedTab {
                case .recent:
                    recent
                case .yourSongs:
                    FileBrowserView()
                }
            }
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(nsColor: .textBackgroundColor))
        }
        //.labelStyle(ButtonLabelStyle())
        .buttonStyle(.plain)
        .toolbar {
            Picker("Tabs", selection: $selectedTab) {
                ForEach(NewTabs.allCases) { tab in
                    Text(tab.rawValue)
                        .tag(tab)
                }
            }
            .pickerStyle(.segmented)
        }
        .frame(width: 640, height: 400)
        .animation(.default, value: selectedTab)
    }
}

extension WelcomeView {
    var recent: some View {
        VStack {
            List {
                ForEach(appState.recentFiles, id: \.self) { url in
                    Button(
                        action: {
                            Task {
                                do {
                                    try await NSDocumentController.shared.openDocument(withContentsOf: url, display: true)
                                } catch {
                                    Logger.application.error("Error opening URL: \(error.localizedDescription, privacy: .public)")
                                }
                            }
                        },
                        label: {
                            Label(url.deletingPathExtension().lastPathComponent, systemImage: "doc.badge.clock")
                        }
                    )
                    .padding(.vertical, 2)
                }
            }
            .scrollContentBackground(.hidden)
            .overlay {
                if appState.recentFiles.isEmpty {
                    Text("You have no recent songs")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

enum NewTabs: String, CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
    case recent = "Recent"
    case yourSongs = "Your Songs"
}

extension WelcomeView {
    struct ButtonLabelStyle: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon
                    .foregroundColor(.accentColor)
                    .imageScale(.large)
                    .frame(width: 30, alignment: .trailing)
                configuration.title
                    .padding(.trailing, 30)
                    //.frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 2)
        }
    }
}
