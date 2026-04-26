//
//  Views+Spinner.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita

extension Views {

    /// The `View` for a custom spinner
    struct Spinner: View {
        /// Start
        let start: Int
        /// End
        let end: Int
        /// The suffix for the displayed value
        let suffix: String
        /// The selected value
        @Binding var value: Int
        /// The body of the `View`
        var view: Body {
            HStack {
                CountButton(
                    value: $value,
                    icon: .goPrevious) {
                        $0 = max($0 - 1, start)
                    }
                Text("\(value) \(suffix)")
                    .frame(minWidth: 100)
                CountButton(
                    value: $value,
                    icon: .goNext) {
                        $0 = min($0 + 1, end)
                    }
            }
            .halign(.center)
        }

        /// The button for the spinner
        private struct CountButton: View {
            @Binding var value: Int
            var icon: Icon.DefaultIcon
            var action: (inout Int) -> Void
            /// The body of the `View`
            var view: Body {
                Button(icon: .default(icon: icon)) {
                    action(&value)
                }
                .circular()
            }
        }
    }
}
