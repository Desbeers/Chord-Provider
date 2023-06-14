//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// The scene for the application
@main struct ChordProviderApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            ContentView(document: file.$document, file: file.fileURL ?? nil)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("")
        }
    }
}
