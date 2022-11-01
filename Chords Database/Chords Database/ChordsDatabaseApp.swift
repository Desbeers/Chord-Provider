//
//  ChordsDatabaseApp.swift
//  Chords Database
//
//  Created by Nick Berendsen on 27/10/2022.
//

import SwiftUI

@main

struct ChordsDatabaseApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ChordsDatabaseDocument()) { file in
            ContentView(document: file.$document)
            
        }
    }
}
