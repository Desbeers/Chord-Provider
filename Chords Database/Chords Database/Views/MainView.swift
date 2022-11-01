//
//  ContentView.swift
//  Chords Database
//
//  Created by Nick Berendsen on 27/10/2022.
//

import SwiftUI
import SwiftyChords

struct MainView: View {
    @EnvironmentObject var model: ChordsDatabaseModel
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @AppStorage("Bad MIDI filter") private var midiFilter = false
    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
            SidebarView()
        }, content: {
            KeyDetailsView()
                .navigationSplitViewColumnWidth(200)
        }, detail: {
            DatabaseView()
        })
        .animation(.default, value: midiFilter)
        .toolbar {
            /// Filter MIDI toggle
            Toggle("Hide good MIDI", isOn: $midiFilter)
            /// New Chord Button
            Button(action: {
                do {
                let newChord = try ChordPosition(id: UUID(),
                                             frets: [0, 0, 0, 0, 0, 0],
                                             fingers: [0, 0, 0, 0, 0, 0],
                                             baseFret: 1,
                                             barres: [],
                                             midi: [48, 52, 55, 60, 64],
                                             key: .c,
                                             suffix: .major
                                             )
                    model.editChord = newChord
                } catch {
                    /// ignore
                }
            }, label: {
                Label("New Chord", systemImage: "plus")
            })
            .labelStyle(.iconOnly)
//            ImportButtonView()
//                .labelStyle(.iconOnly)
//                .help("Import your database")
//            ExportButtonView()
//                .labelStyle(.iconOnly)
//                .help("Export your database")
        }
        .sheet(item: $model.editChord) { chord in
            ChordEditView(chord: chord)
        }
    }
}
