//
//  ChordsDatabaseModel.swift
//  Chords Database
//
//  Created by Nick Berendsen on 27/10/2022.
//

import SwiftUI
import SwiftyChords

class ChordsDatabaseModel: ObservableObject {
    
    @Published var allChords: [ChordPosition] = []
    
    @Published var selectedKey: Chords.Key = .c
    @Published var selectedSuffix: Chords.Suffix?
    
    @Published var editChord: ChordPosition?
    
    /// Update document toggle
    @Published var updateDocument: Bool = false
    
    var exportDB: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let encodedData = try encoder.encode(allChords)
            let jsonString = String(data: encodedData,
                                    encoding: .utf8)
            return jsonString ?? "error"
        } catch {
            return "error"
        }
    }
    
    func importDB(database: String) {
        do {
            if let data = database.data(using: .utf8) {
                let chords = try JSONDecoder().decode([ChordPosition].self,
                                                      from: data)
                allChords = chords.sorted { $0.key == $1.key ? $0.suffix < $1.suffix : $0.key < $1.key }
                print("Import done")
            }
        } catch {
            print("error")
        }
    }
    static func getChords() -> [ChordPosition] {
        SwiftyChords.Chords.guitar
            .sorted { $0.key == $1.key ? $0.suffix < $1.suffix : $0.key < $1.key }
    }
    @ViewBuilder func diagram(chord: ChordPosition, frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 150)) -> some View {
        let layer = chord.chordLayer(rect: frame, showFingers: true)
        if let image = layer.image() {
#if os(macOS)
            Image(nsImage: image)
#endif
#if os(iOS)
            Image(uiImage: image)
#endif
        } else {
            Image(systemName: "music.note")
        }
    }
}
