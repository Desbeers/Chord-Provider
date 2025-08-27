//
//  File.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 27/08/2025.
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

struct RenderView: View {    
    let render: String

    var view: Body {
        ScrollView {
            Text(render)
                .wrap()
                .hexpand()
                .padding(20)
                .halign(.fill)
        }
    }
}
