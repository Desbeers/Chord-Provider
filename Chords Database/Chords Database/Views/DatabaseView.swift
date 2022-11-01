//
//  DatabaseView.swift
//  Chords Database
//
//  Created by Nick Berendsen on 27/10/2022.
//

import SwiftUI
import SwiftyChords

struct DatabaseView: View {
    @EnvironmentObject var model: ChordsDatabaseModel
    
    @AppStorage("Bad MIDI filter") private var midiFilter = false

    @State var chords: [SwiftyChords.ChordPosition] = []
    
    var body: some View {
        Table(chords) {
            TableColumn("Diagram") { chord in
                model.diagram(chord: chord)
            }
            TableColumn("Chord") { chord in
                Text(chord.key.display.symbol + chord.suffix.display.symbolized)
            }
            TableColumn("Full") { chord in
                Text(chord.key.display.accessible + chord.suffix.display.accessible)
            }
            TableColumn("Base fret") { chord in
                Text(chord.baseFret.description)
            }
            TableColumn("Midi") { chord in
                Text(chord.midi == MidiNotes.values(values: chord) ? "Correct" : "Wrong")
                    .font(.headline)
            }
            TableColumn("Action") { chord in
                VStack {
                    editButton(chord: chord)
                    deleteButton(chord: chord)
                    duplicateButton(chord: chord)
                }
                .buttonStyle(.bordered)
            }
        }
        .id(model.selectedKey)
        .task(id: model.allChords) {
            filterChords()
        }
        .task(id: model.selectedKey) {
            filterChords()
        }
        .task(id: model.selectedSuffix) {
            filterChords()
        }
        .task(id: midiFilter) {
            filterChords()
        }
    }
    
    func filterChords() {
        var allChords = model.allChords.filter({$0.key == model.selectedKey})
        if let suffix = model.selectedSuffix {
            allChords = allChords.filter({$0.suffix == suffix})
        }
        
        if midiFilter {
            allChords = allChords.filter({$0.midi != MidiNotes.values(values: $0)})
        }
        
        chords = allChords
    }

    func editButton(chord: ChordPosition) -> some View {
        Button(action: {
            model.editChord = chord
        }, label: {
            Text("Edit")
        })
    }
    
    func deleteButton(chord: ChordPosition) -> some View {
        Button(action: {
            if let chordIndex = model.allChords.firstIndex(where: {$0.id == chord.id}) {
                model.allChords.remove(at: chordIndex)
            }
        }, label: {
            Text("Delete")
        })
    }
    
    func duplicateButton(chord: ChordPosition) -> some View {
        Button(action: {
            do {
            let newChord = try ChordPosition(id: UUID(),
                                             frets: chord.frets,
                                             fingers: chord.fingers,
                                             baseFret: chord.baseFret,
                                             barres: chord.barres,
                                             midi: chord.midi,
                                             key: chord.key,
                                             suffix: chord.suffix
                                         )
                model.editChord = newChord
            } catch {
                /// ignore
            }
        }, label: {
            Text("Duplicate")
        })
    }
}
