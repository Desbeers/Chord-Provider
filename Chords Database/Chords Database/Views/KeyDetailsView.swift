//
//  KeyDetailsView.swift
//  Chords Database
//
//  Created by Nick Berendsen on 27/10/2022.
//

import SwiftUI
import SwiftyChords

struct KeyDetailsView: View {
    @EnvironmentObject var model: ChordsDatabaseModel
    @State var suffixes: [SwiftyChords.ChordPosition] = []
    @AppStorage("Bad MIDI filter") private var midiFilter = false
    var body: some View {
        List(selection: $model.selectedSuffix) {
            ForEach(suffixes) { suffix in
                HStack {
                    Text("\(suffix.key.rawValue)")
                        .font(.headline)
                    Text("\(suffix.suffix.display.symbolized)")
                }
                    .tag(suffix.suffix)
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
//        .task(id: model.allChords) {
//            filterSuffixes()
//        }
        .task(id: model.selectedKey) {
            filterSuffixes()
        }
        .task(id: midiFilter) {
            filterSuffixes()
        }
    }
    
    func filterSuffixes() {
        var allSuffixes = model.allChords.filter({$0.key == model.selectedKey})
        if midiFilter {
            allSuffixes = allSuffixes.filter({$0.midi != MidiNotes.values(values: $0)})
        }
        suffixes = allSuffixes.unique { $0.suffix }
    }
}
