//
//  SidebarView.swift
//  Chords Database
//
//  Created by Nick Berendsen on 27/10/2022.
//

import SwiftUI
import SwiftyChords

struct SidebarView: View {
    @EnvironmentObject var model: ChordsDatabaseModel
    @State var kays: [Chords.Key] = []
    var body: some View {
        List(selection: $model.selectedKey) {
            ForEach(model.allChords.unique { $0.key }) { key in
                Text(key.key.display.symbol)
                    .tag(key.key)
            }
        }
        .onChange(of: model.selectedKey) { _ in
            model.selectedSuffix = nil
        }
    }
}
