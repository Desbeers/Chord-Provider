//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The scene for the application
@main struct ChordProviderApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            ContentView(document: file.$document, file: file.fileURL ?? nil)
            /// Below needed or else we get a double navigation
            /// See https://developer.apple.com/forums/thread/714430
                .toolbarRole(.automatic)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("")
        }
    }
}
