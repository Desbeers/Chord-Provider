//
//  FontSizeSlider.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
/// SwiftUI `View` for a font size slider
struct FontSizeSlider: View {
    /// The selected font size
    @Binding var fontSize: Double
    /// The range of font sizes
    var range: ClosedRange<Double> = 6...24
    /// The label for the slider
    let label: FontSizeLabel
    var body: some View {
        HStack {
            Text(label == .symbol ? "A" : Int(range.lowerBound).description)
                .font(.system(size: max(range.lowerBound, 10)))
            Slider(
                value: $fontSize,
                in: range,
                step: 1
            )
            Text(label == .symbol ? "A" : Int(range.upperBound).description)
                .font(.system(size: min(range.upperBound, 18)))
        }
        .foregroundColor(.secondary)
    }
    /// Label options
    enum FontSizeLabel {
        /// Show as number
        case number
        /// Show as symbol
        case symbol
    }
}
