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
    @Binding var options: ConfigOptions.FontOptions
    /// The available fonts of a font-family
    @State private var fontStyles: [FontStyle] = []
    /// The body of the `View`
    var body: some View {
        VStack {
            HStack {
                Picker(selection: $options.fontFamily) {
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
                        Text(style.style)
                            .font(.custom(style.postScriptName, size: NSFont.preferredFont(forTextStyle: .body).pointSize))
                            .tag(style.postScriptName)
                    }
                } label: {
                    Text("Style")
                }
            }
            .labelsHidden()
        }
        .task(id: options.fontFamily) {
            if let familyFonts = NSFontManager.shared.availableMembers(ofFontFamily: options.fontFamily) {
                fontStyles = familyFonts.map { family in
                    return FontStyle(
                        postScriptName: family[0] as? String ?? "SFPro-Regular",
                        style: family[1] as? String ?? "Regular"
                    )
                }
                if let selectedFont = fontStyles.first(where: { $0.postScriptName == options.font }) {
                    options.font = selectedFont.postScriptName
                } else if let first = fontStyles.first {
                    options.font = first.postScriptName
                }
            }
        }
        .animation(.default, value: options.nsFont)
    }
    /// Structure of a font style
    private struct FontStyle {
        /// The postscript name
        let postScriptName: String
        /// The style, *italic* for example
        let style: String
    }
}
