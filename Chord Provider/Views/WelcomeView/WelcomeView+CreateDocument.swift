//
//  WelcomeView+CreateDocument.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

extension WelcomeView {

    /// SwiftUI `View` for creating a new document
    @MainActor struct CreateDocument: View {
        /// The observable state of the application
        @State private var appState = AppStateModel.shared
        /// The AppDelegate to bring additional Windows into the SwiftUI world
        let appDelegate: AppDelegateModel
        /// The body of the `View`
        var body: some View {
            VStack {
                Text("Chord Provider")
                    .font(.title)
                    .bold()
                    .padding(.top)
                // swiftlint:disable:next force_unwrapping
                Image(nsImage: NSImage(named: "AppIcon")!)
                    .resizable()
                    .frame(width: 280, height: 280)
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
                    Button(
                        action: {
                            appDelegate.showChordsDatabaseView()
                        },
                        label: {
                            Label("View Chord Diagrams", systemImage: "hand.raised.fingers.spread")
                        }
                    )
                }
                .padding(.trailing)
                .labelStyle(.createDocument)
            }
        }
    }
}
