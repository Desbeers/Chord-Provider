//
//  FontPicker.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with a font picker
struct FontPicker: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// The font options
    @Binding var options: FontUtils.Options
    /// The available fonts of a font-family
    @State private var fontStyles: [FontUtils.Item] = []
    /// The currently selected family name
    @State private var familyName: String = ""
    /// The body of the `View`
    var body: some View {
        VStack {
            HStack {
                Picker(selection: $familyName) {
                    ForEach(appState.fontFamilies) { family in
                        Text(family)
                            .font(.custom(family, size: NSFont.preferredFont(forTextStyle: .body).pointSize))
                            .tag(family)
                    }
                } label: {
                    Text("Family")
                }
                Picker(selection: $options.font) {
                    ForEach(fontStyles, id: \.postScriptName) { style in
                        Text(style.styleName)
                            .font(.custom(style.postScriptName, size: NSFont.preferredFont(forTextStyle: .body).pointSize))
                            .tag(style)
                    }
                } label: {
                    Text("Style")
                }
            }
            .labelsHidden()
        }
        .task {
            familyName = options.font.familyName
        }
        .task(id: familyName) {
            fontStyles = appState.fonts.filter { $0.familyName == familyName }
            if let selectedFont = fontStyles.first(where: { $0.postScriptName == options.font.postScriptName }) {
                options.font = selectedFont
            } else if let first = fontStyles.first {
                options.font = first
            }
        }
        .animation(.default, value: options.nsFont(scale: 1))
    }
}
