//
//  ContentView.swift
//  Chords Database
//
//  Created by Nick Berendsen on 30/10/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ChordsDatabaseModel()
    @Binding var document: ChordsDatabaseDocument
    var body: some View {
        MainView()
            .environmentObject(model)
        /// Import the chords
            .task {
                if document.text == "default" {
                    /// Load the default database
                    model.allChords = ChordsDatabaseModel.getChords()
                } else {
                    /// Load the content of the document
                    model.importDB(database: document.text)
                }
            }
        /// Store changes of chords in the document
            .onChange(of: model.updateDocument ) { _ in
                document.text = model.exportDB
            }
    }
}
