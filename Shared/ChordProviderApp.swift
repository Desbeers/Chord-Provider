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
        DocumentGroup(newDocument: ChordProviderDocument()) { file in
            MainView(document: file.$document)
        
        }
        

    }
}
