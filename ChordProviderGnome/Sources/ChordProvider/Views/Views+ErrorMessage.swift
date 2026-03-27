//
//  Views+ErrorMessage.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension Views {

    /// A `View` that shows an error message
    struct ErrorMessage: View {
        /// The underlying error
        let error: ChordProviderError?
        /// The body of the `View`
        var view: Body {
            if let error {
                VStack {
                    if let recoverySuggestion = error.recoverySuggestion {
                        Text(recoverySuggestion)
                            .style(.bold)
                    }
                    Text(error.failureReason ?? "Unknown reason")
                        .wrap()
                        .monospace()
                        .vexpand()
                        .padding()
                }
            } else {
                Text("Unknown Error")
            }
        }
    }
}
