//
//  NewDocumentView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 11/08/2024.
//

import SwiftUI
import OSLog

@MainActor struct NewDocumentView: View {
    /// The state of the app
    @State private var appState = AppState.shared
    @State private var selectedTab: NewTabs = .recent

    var body: some View {
        HStack(spacing: 0) {
            if selectedTab != .exportFolder {
                VStack(spacing: 10) {
                    // swiftlint:disable:next force_unwrapping
                    Image(nsImage: NSImage(named: "AppIcon")!)
                        .resizable()
                        .frame(width: 240, height: 240)
                        .transition(.slide)
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
                }
                .frame(maxHeight: .infinity)
                .padding(.leading)
                .background(Color.telecaster)
            }
            VStack {
                switch selectedTab {
                case .recent:
                    recent
                case .yourSongs:
                    FileBrowserView()
                case .exportFolder:
                    ExportFolderView()
                }
            }
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(nsColor: .textBackgroundColor))
        }
        .labelStyle(ButtonLabelStyle())
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
        .frame(width: 600, height: 400)
        .animation(.default, value: selectedTab)
        .labelStyle(ButtonLabelStyle())
    }
}

extension NewDocumentView {
    var recent: some View {
        VStack {
            if appState.recentFiles.isEmpty {
                Text("You have no recent songs")
            } else {
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
                    }
                }
                .scrollContentBackground(.hidden)
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
    case exportFolder = "Export Folder"
}

extension NewDocumentView {
    struct ButtonLabelStyle: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon
                    .foregroundColor(.accentColor)
                    .imageScale(.large)
                configuration.title
                    .frame(width: 200, alignment: .leading)
            }
        }
    }
}
