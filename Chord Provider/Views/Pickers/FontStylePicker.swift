//
//  FontStylePicker.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

struct FontStylePicker: View {
    @Binding var style: ConfigOptions.FontStyle
    var body: some View {
        Picker("Font style", selection: $style) {
            ForEach(ConfigOptions.FontStyle.allCases, id: \.self) { font in
                Text("\(font.rawValue)")
                    .font(font.body)
            }
        }
    }
}
