//
//  Views+SortTokens.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` to edit or add sort tokens
    struct SortTokens: View {
        /// The sort tokens
        @Binding var  sortTokens: [String]
        /// The token to add
        @State private var token: String = ""
        /// The tokens for to show in the UI
        @State private var tokens: [String.ElementWrapper]
        /// Init the tokens `View`
        init(sortTokens: Binding<[String]>) {
            self._sortTokens = sortTokens
            self._tokens = State(wrappedValue: Views.SortTokens.mapTokens(sortTokens.wrappedValue))
        }
        /// The default tokens
        static let defaults = ChordProviderSettings().sortTokens
        /// The body of the `View`
        var view: Body {
            VStack {
                Text("Add or delete articles to ignore when sorting songs and artists")
                    .halign(.start)
                    .padding()
                HStack {
                    Entry("New Token", text: $token)
                        .padding(.horizontal)
                    Button("Add") {
                        sortTokens.append(token)
                        tokens = Views.SortTokens.mapTokens(sortTokens)
                        token = ""
                    }
                    .insensitive(token.isEmpty || sortTokens.contains(token))
                    Text("")
                        .hexpand()
                    Button("Default") {
                        sortTokens = Views.SortTokens.defaults
                        tokens = Views.SortTokens.mapTokens(sortTokens)
                        token = ""
                    }
                    .insensitive(sortTokens.sorted() == Views.SortTokens.defaults.sorted())
                    .padding(.trailing)
                }
                .valign(.center)
                FlowBox(tokens, selection: nil) { token in
                    HStack {
                        Text(token.content)
                            .hexpand()
                        Button(icon: .default(icon: .editDelete)) {
                            tokens = tokens.filter { $0.id != token.id }
                            sortTokens = tokens.map(\.content)
                        }
                        .flat()
                    }
                    .frameStyle()
                }
                .valign(.center)
                .padding()
            }
        }

        /// Map the tokens into an indentifiable structure
        /// - Parameter tokens: The array of tokens
        /// - Returns: The tokens in a indentifiable structure
        static func mapTokens(_ tokens: [String]) -> [String.ElementWrapper] {
            tokens.toElementWrapper.sorted { (lhs: String.ElementWrapper, rhs: String.ElementWrapper) -> Bool in
                lhs.content.localizedStandardCompare(rhs.content) == .orderedAscending
            }
        }
    }
}
