//
//  FontWeightPicker.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

struct FontWeightPicker: View {
    @Binding var weight: ConfigOptions.FontWeight
    var body: some View {
        Picker("Font weight", selection: $weight) {
            ForEach(ConfigOptions.FontWeight.allCases, id: \.self) { font in
                Text("\(font.rawValue)")
                    .font(font.body)
            }
        }
    }
}
