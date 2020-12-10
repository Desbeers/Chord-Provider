//
//  ChordProviderApp.swift
//  Shared
//
//  Created by Nick Berendsen on 28/11/2020.
//

import SwiftUI

@main
struct ChordProviderApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            MainView(document: file.$document, chordpro: ChordPro.parse(file.document))
        }
    }
}
