//
//  WelcomeView+createDocument.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension WelcomeView {

    /// Create document `View`
    var createDocument: some View {
        VStack {
            ImageUtils.applicationIcon()
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
                        Label("Open a **ChordPro** Song", systemImage: "document.badge.ellipsis")
                    }
                )
                Button(
                    action: {
                        openWindow(id: AppDelegate.WindowID.exportFolderView.rawValue)
                        dismiss()
                    },
                    label: {
                        Label("Export a Folder with Songs", systemImage: "document.on.document")
                    }
                )
                Button(
                    action: {
                        openWindow(id: AppDelegate.WindowID.chordsDatabaseView.rawValue)
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
