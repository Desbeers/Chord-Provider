//
//  FontPickerButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with a button to open the font picker in a popup
struct FontPickerButton: View {
    /// The options for the font
    @Binding var options: FontUtils.Options
    /// Bool to show the popup
    @State private var showPopup: Bool = false
    /// The body of the `View`
    var body: some View {
        Button {
            showPopup = true
        } label: {
            Image(systemName: "textformat")
        }
        .popover(isPresented: $showPopup) {
            FontPicker(options: $options)
                .padding()
        }
    }
}
