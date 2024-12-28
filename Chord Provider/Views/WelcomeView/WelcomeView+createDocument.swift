//
//  WelcomeView+createDocument.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

extension WelcomeView {
    var createDocument: some View {
        VStack {
            Text("Chord Provider")
                .font(.title)
                .bold()
            // swiftlint:disable:next force_unwrapping
            Image(nsImage: NSImage(named: "AppIcon")!)
                .resizable()
                .frame(width: 240, height: 240)
            VStack(alignment: .leading) {
                Button(
                    action: {
                        NSDocumentController.shared.newDocument(nil)
                    },
                    label: {
                        Label("Start with a New Song", systemImage: "doc")
                    }
                )
                Button(
                    action: {
                        Task {
                            if let urls = await NSDocumentController.shared.beginOpenPanel() {
                                for url in urls {
                                    await openSong(url: url)
                                }
                            }
                        }
                    },
                    label: {
                        Label("Open a **ChordPro** Song", systemImage: "doc.badge.ellipsis")
                    }
                )
                Button(
                    action: {
                        openWindow(id: AppDelegateModel.WindowID.exportFolderView.rawValue)
                        dismiss()
                    },
                    label: {
                        Label("Export a Folder with Songs", systemImage: "doc.on.doc")
                    }
                )
                Button(
                    action: {
                        openWindow(id: AppDelegateModel.WindowID.chordsDatabaseView.rawValue)
                        dismiss()
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
