//
//  FontSizeSlider.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

struct FontSizeSlider: View {
    @Binding var fontSize: Double
    var range: ClosedRange<Double> = 6...24
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

    enum FontSizeLabel {
        case number
        case symbol
    }
}
