//
//  Views+Spinner.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita

extension Views {

    /// The `View` for a custom spinner
    struct Spinner: View {
        /// Min
        let min: Int
        /// Max
        let max: Int
        /// Optional default
        var defaultValue: Int?
        /// The suffix for the displayed value
        let suffix: String
        /// The selected value
        @Binding var value: Int
        /// The body of the `View`
        var view: Body {
            HStack {
                SpinRow("", value: $value, min: min, max: max)
                    .suffix {
                        Text(suffix)
                    }
                    .frame(minWidth: 200)
                if let defaultValue {
                    Button("Default") {
                        value = defaultValue
                    }
                    .padding(.leading)
                    .insensitive(value == defaultValue)
                    .valign(.center)
                }
            }
        }
    }
}
