//
//  ImportExportView.swift
//  Chords Database
//
//  Created by Nick Berendsen on 27/10/2022.
//

import SwiftUI
import UniformTypeIdentifiers

/// The SwiftUI 'export' button
struct ExportButtonView: View {
    @EnvironmentObject var model: ChordsDatabaseModel
    @State private var exportFile = false
    var body: some View {
        Button(action: {
            exportFile = true
        }, label: {
            Label("Export database", systemImage: "square.and.arrow.up")
        })
        .fileExporter(isPresented: $exportFile,
                      document: ChordsDatabaseDocument(text: model.exportDB),
                      contentType: .cdb, defaultFilename: "Chords Database",
                      onCompletion: { result in
            if case .success = result {
                print("Success")
            } else {
                print("Failure")
            }
        })
    }
}

/// The SwiftUI 'import' button
struct ImportButtonView: View {
    @EnvironmentObject var model: ChordsDatabaseModel
    @State private var importFile = false
    var body: some View {
        Button(action: {
            importFile = true
        }, label: {
            Label("Export database", systemImage: "square.and.arrow.down")
        })
        .fileImporter(
            isPresented: $importFile,
            allowedContentTypes: [.cdb],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else {
                    return
                }
                guard let database = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else {
                    return
                }
                model.importDB(database: database)
            } catch {
                // Handle failure.
            }
        }
    }
}
